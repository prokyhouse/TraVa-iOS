//
//  MovieAPI.swift
//  Networking
//
//  Created by Кирилл Прокофьев on 24.03.2023.
//

import Foundation

import Domain
import Moya

/// Эндпоинты OMDb (https://www.omdbapi.com).
/// API-ключ сюда намеренно не входит — его добавляет `APIKeyPlugin`.
enum MovieAPI {
    /// Фильм по IMDb ID
    case movie(id: Movie.ID)

    /// Поиск по названию (по 10 результатов на страницу, страницы 1...100)
    case search(query: String, year: Int?, type: MediaType?, page: Int)
}

extension MovieAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://www.omdbapi.com/") else {
            fatalError("[NETWORK 🌐] BaseURL could not be configured.")
        }
        return url
    }

    var path: String {
        return ""
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        var parameters = [String: Any]()

        switch self {
            case let .movie(id):
                parameters["i"] = id
                parameters["plot"] = "full"

            case let .search(query, year, type, page):
                parameters["s"] = query
                parameters["page"] = page
                if let year {
                    parameters["y"] = year
                }
                if let type {
                    parameters["type"] = type.rawValue
                }
        }

        return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }

    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
}
