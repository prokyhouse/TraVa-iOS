//
//  NetworkManager.swift
//  Networking
//
//  Created by Кирилл Прокофьев on 24.03.2023.
//

import Foundation
import Moya
import Domain

protocol Network {
    associatedtype T: TargetType
    var provider: MoyaProvider<T> { get }
}

public protocol Networkable {
    func fetchUpcomingMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> ())
    func fetchPopularMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> ())
    func fetchMovie(movie: Int, completion: @escaping (Result<Movie, Error>) -> ())
}

public struct NetworkService: Network {
    static let MovieAPIKey = "2e774b038b2dc15a1db7397f1b6b63a7"
    let provider = MoyaProvider<MovieAPI>()

    public init() { }
}

extension NetworkService: Networkable {
    public func fetchMovie(movie: Int, completion: @escaping (Result<Movie, Error>) -> ()) {
        provider.request(.movie(id: movie)) { result in
            switch result {
            case let .success(response):
                do {
                    let movie = try JSONDecoder().decode(
                        Domain.Movie.self,
                        from: response.data
                    )
                    completion(.success(movie))
                } catch let error {
                    print("[NETWORK 🌐] \(error.localizedDescription)")
                    completion(.failure(error))
                }

            case let .failure(error):
                print("[NETWORK 🌐] \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    public func fetchUpcomingMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> ()) {
        provider.request(.movies(type: .upcoming, page: page)) { result in
            switch result {
            case let .success(response):
                do {
                    let moviesPage = try JSONDecoder().decode(
                        Domain.MoviesPage.self,
                        from: response.data
                    )
                    completion(.success(moviesPage.results))
                } catch let error {
                    print("[NETWORK 🌐] \(error.localizedDescription)")
                    completion(.failure(error))
                }

            case let .failure(error):
                print("[NETWORK 🌐] \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    public func fetchPopularMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> ()) {
        provider.request(.movies(type: .popular, page: page)) { result in
            switch result {
            case let .success(response):
                do {
                    let moviesPage = try JSONDecoder().decode(
                        Domain.MoviesPage.self,
                        from: response.data
                    )
                    completion(.success(moviesPage.results))
                } catch let error {
                    print("[NETWORK 🌐] \(error.localizedDescription)")
                    completion(.failure(error))
                }

            case let .failure(error):
                print("[NETWORK 🌐] \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}

