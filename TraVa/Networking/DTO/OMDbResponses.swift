//
//  OMDbResponses.swift
//  Networking
//
//  Created by Кирилл Прокофьев on 22.10.2026.
//

import Foundation

// MARK: - Status

/// Общая часть любого ответа OMDb. Ошибки приходят не HTTP-кодом,
/// а полями `"Response": "False"` и `"Error": "..."`.
struct OMDbStatusDTO: Decodable {
    let response: String
    let error: String?

    var isSuccess: Bool {
        response.caseInsensitiveCompare("True") == .orderedSame
    }

    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case error = "Error"
    }
}

// MARK: - Search

struct OMDbSearchResponseDTO: Decodable {
    let search: [OMDbSearchItemDTO]
    let totalResults: String?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
    }
}

struct OMDbSearchItemDTO: Decodable {
    let title: String?
    let year: String?
    let imdbID: String
    let type: String?
    let poster: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

// MARK: - Movie

struct OMDbMovieDTO: Decodable {
    let title: String?
    let year: String?
    let released: String?
    let runtime: String?
    let genre: String?
    let director: String?
    let writer: String?
    let actors: String?
    let plot: String?
    let poster: String?
    let ratings: [OMDbRatingDTO]?
    let imdbRating: String?
    let imdbVotes: String?
    let imdbID: String
    let type: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case poster = "Poster"
        case ratings = "Ratings"
        case imdbRating, imdbVotes, imdbID
        case type = "Type"
    }
}

struct OMDbRatingDTO: Decodable {
    let source: String
    let value: String

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}
