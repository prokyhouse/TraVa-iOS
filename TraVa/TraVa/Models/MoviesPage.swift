//
//  MoviesPage.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import Foundation

// MARK: - MoviesPage
struct MoviesPage: Decodable {
	let page: Int
	let results: [Movie]
	let totalPages, totalResults: Int

	enum CodingKeys: String, CodingKey {
		case page, results
		case totalPages = "total_pages"
		case totalResults = "total_results"
	}
}
