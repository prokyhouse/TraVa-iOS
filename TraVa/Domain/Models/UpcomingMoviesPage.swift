//
//  UpcomingMoviesPage.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 24.12.2021.
//

import Foundation

// MARK: - UpcomingMoviesPage
public struct UpcomingMoviesPage: Decodable {
    public let dates: Dates
    public let page: Int
    public let results: [Movie]
    public let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
public struct Dates: Decodable {
    public let maximum, minimum: String
}
