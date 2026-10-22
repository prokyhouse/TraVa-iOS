//
//  NetworkManager.swift
//  Networking
//
//  Created by Кирилл Прокофьев on 24.03.2023.
//

import Alamofire
import Domain
import Foundation
import Moya

protocol Network {
    associatedtype T: TargetType
    var provider: MoyaProvider<T> { get }
}

public protocol Networkable {
    func fetchUpcomingMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)
    func fetchPopularMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)
    func fetchMovie(movie: Movie.ID, completion: @escaping (Result<Movie, Error>) -> Void)
}

public struct NetworkService: Network {
    let provider: MoyaProvider<MovieAPI>

    private let keyProvider: APIKeyProviding
    private let catalog: MovieCatalog
    private let cache = MovieCache()

    public init() {
        self.init(keyProvider: BuildTimeAPIKeyProvider(), catalog: .default)
    }

    public init(keyProvider: APIKeyProviding, catalog: MovieCatalog) {
        self.keyProvider = keyProvider
        self.catalog = catalog

        // Ephemeral-сессия не пишет ответы в дисковый URLCache: иначе URL с `apikey`
        // в открытом виде оседал бы в Library/Caches. Повторные запросы закрывает `MovieCache`.
        let configuration = URLSessionConfiguration.ephemeral
        configuration.headers = .default
        self.provider = MoyaProvider<MovieAPI>(
            session: Session(configuration: configuration, startRequestsImmediately: false),
            plugins: [APIKeyPlugin(keyProvider: keyProvider)]
        )
    }
}

// MARK: - Networkable

extension NetworkService: Networkable {
    public func fetchMovie(movie: Movie.ID, completion: @escaping (Result<Movie, Error>) -> Void) {
        if let cached = cache.movie(for: movie) {
            completion(.success(cached))
            return
        }

        request(.movie(id: movie), as: OMDbMovieDTO.self) { [cache] result in
            completion(result.map { dto in
                let movie = OMDbMapper.movie(from: dto)
                cache.store(movie)
                return movie
            })
        }
    }

    public func fetchUpcomingMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let year = Calendar.current.component(.year, from: Date())
        let terms = catalog.upcomingSearchTerms
        let group = DispatchGroup()
        var resultsByTerm = [[Movie]](repeating: [], count: terms.count)
        var firstError: Error?

        // Колбэки Moya приходят на main queue, поэтому общие переменные меняются последовательно
        for (index, term) in terms.enumerated() {
            group.enter()
            request(.search(query: term, year: year, type: .movie, page: page), as: OMDbSearchResponseDTO.self) { result in
                switch result {
                    case let .success(response):
                        resultsByTerm[index] = response.search.map(OMDbMapper.movie(from:))

                    case let .failure(error):
                        firstError = firstError ?? error
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            let movies = Self.interleaved(resultsByTerm).filter { $0.posterURL != nil }

            if movies.isEmpty, let firstError {
                completion(.failure(firstError))
            } else {
                completion(.success(movies))
            }
        }
    }

    public func fetchPopularMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let start = max(page - 1, 0) * catalog.pageSize
        guard start < catalog.popularIDs.count else {
            completion(.success([]))
            return
        }

        let end = min(start + catalog.pageSize, catalog.popularIDs.count)
        fetchMovies(ids: Array(catalog.popularIDs[start..<end]), completion: completion)
    }
}

// MARK: - Private Methods

private extension NetworkService {
    func fetchMovies(ids: [Movie.ID], completion: @escaping (Result<[Movie], Error>) -> Void) {
        let group = DispatchGroup()
        var movies = [Movie?](repeating: nil, count: ids.count)
        var firstError: Error?

        for (index, id) in ids.enumerated() {
            group.enter()
            fetchMovie(movie: id) { result in
                switch result {
                    case let .success(movie):
                        movies[index] = movie

                    case let .failure(error):
                        firstError = firstError ?? error
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            let loaded = movies.compactMap { $0 }

            if loaded.isEmpty, let firstError {
                completion(.failure(firstError))
            } else {
                completion(.success(loaded))
            }
        }
    }

    func request<DTO: Decodable>(
        _ target: MovieAPI,
        as type: DTO.Type,
        completion: @escaping (Result<DTO, Error>) -> Void
    ) {
        // Без ключа OMDb всё равно ответит ошибкой — не тратим запрос из суточного лимита
        do {
            _ = try keyProvider.apiKey()
        } catch let error {
            log(error)
            completion(.failure(error))
            return
        }

        provider.request(target) { result in
            switch result {
                case let .success(response):
                    let decoded = Self.decode(DTO.self, from: response.data)
                    if case let .failure(error) = decoded {
                        log(error)
                    }
                    completion(decoded)

                case let .failure(error):
                    let error = NetworkError.transport(error)
                    log(error)
                    completion(.failure(error))
            }
        }
    }

    static func decode<DTO: Decodable>(_ type: DTO.Type, from data: Data) -> Result<DTO, Error> {
        let decoder = JSONDecoder()

        do {
            let status = try decoder.decode(OMDbStatusDTO.self, from: data)
            guard status.isSuccess else {
                return .failure(NetworkError.api(message: status.error ?? "Unknown OMDb error"))
            }
            return .success(try decoder.decode(DTO.self, from: data))
        } catch let error {
            return .failure(NetworkError.decoding(error))
        }
    }

    /// Чередует результаты разных поисковых запросов и убирает дубликаты,
    /// чтобы выдача не состояла из фильмов только по первому слову.
    static func interleaved(_ lists: [[Movie]]) -> [Movie] {
        var seen = Set<Movie.ID>()
        var result = [Movie]()
        let longest = lists.map(\.count).max() ?? 0

        for index in 0..<longest {
            for list in lists where index < list.count {
                let movie = list[index]
                if seen.insert(movie.id).inserted {
                    result.append(movie)
                }
            }
        }
        return result
    }

    /// Логируем только описание ошибки, без URL: в query находится API-ключ
    func log(_ error: Error) {
        #if DEBUG
        print("[NETWORK 🌐] \(error.localizedDescription)")
        #endif
    }
}

// MARK: - MovieCache

/// Кэш карточек фильмов в памяти. Бесплатный ключ OMDb ограничен 1000 запросов в сутки,
/// а одни и те же фильмы показываются на нескольких экранах.
private final class MovieCache {
    private let lock = NSLock()
    private var movies = [Movie.ID: Movie]()

    func movie(for id: Movie.ID) -> Movie? {
        lock.lock()
        defer { lock.unlock() }
        return movies[id]
    }

    func store(_ movie: Movie) {
        lock.lock()
        defer { lock.unlock() }
        movies[movie.id] = movie
    }
}
