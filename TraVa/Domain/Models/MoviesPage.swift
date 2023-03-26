//
//  MoviesPage.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import Foundation

// MARK: - MoviesPage
public struct MoviesPage: Codable {
	public let page: Int
    public let results: [Movie]
    public let totalPages, totalResults: Int

    public init(page: Int, results: [Movie], totalPages: Int, totalResults: Int) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
