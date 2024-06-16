//
//  MovieAPI.swift
//  Networking
//
//  Created by Кирилл Прокофьев on 24.03.2023.
//

import Foundation

import Moya

enum MovieAPI {
    /// Список фильмов
    case movies(type: MoviesType, page: Int)

    /// Фильм
    case movie(id: Int)

    // case actors(movieID: Int)

    /// Поиск
    case search(String, Int)

    /// Список рекомендаций к фильму
    case recommendations(id: Int)

    /// Список видео-материалов к фильму
    case video(id: Int)

    /// Список изображение к фильму
    case image(ImageSize, String)
}

enum MoviesType {
    case popular
    case new
    case upcoming
}

enum ImageSize: String {
    case original
    case w500
}

extension MovieAPI: TargetType {
    var baseURL: URL {

        switch self {
            case .image:
                guard let url = URL(string: "https://image.tmdb.org/t/p/") else {
                    fatalError("[NETWORK 🌐] BaseURL for image could not be configured.")
                }
                return url

            default:
                guard let url = URL(string: "https://api.themoviedb.org/3/movie/") else {
                    fatalError("[NETWORK 🌐] BaseURL could not be configured.")
                }
                return url
        }
    }

    var path: String {
        switch self {
            case .movies(type: let type, _):
                switch type {
                    case .popular:
                        return "popular"

                    case .new:
                        return "now_playing"

                    case .upcoming:
                        return "upcoming"
                }

            case let .recommendations(id):
                return "\(id)/recommendations"

            case .search:
                return "search/movie"

            case let .image(imageSize, path):
                return "\(imageSize)/\(path)"

            case let .video(id):
                return "\(id)/videos"

            case let .movie(id):
                return "\(id)"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        var parameters = [String: Any]()
        parameters["api_key"] = NetworkService.MovieAPIKey

        switch self {
            case .recommendations, .video:
                break

            case .movies(_, let page):
                parameters["page"] = page

            case .search(let query, let page):
                parameters["query"] = query
                parameters["page"] = page

            case .image:
                break
            case .movie:
                parameters["append_to_response"] = "credits,videos"
        }

        return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
