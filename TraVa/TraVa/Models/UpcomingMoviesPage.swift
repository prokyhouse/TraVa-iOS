//
//  UpcomingMoviesPage.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 24.12.2021.
//

import Foundation

// MARK: - UpcomingMoviesPage
struct UpcomingMoviesPage: Decodable {
	let dates: Dates
	let page: Int
	let results: [Movie]
	let totalPages, totalResults: Int

	enum CodingKeys: String, CodingKey {
		case dates, page, results
		case totalPages = "total_pages"
		case totalResults = "total_results"
	}
}

// MARK: - Dates
struct Dates: Decodable {
	let maximum, minimum: String
}
