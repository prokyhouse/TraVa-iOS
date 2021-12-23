//
//  Movie.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//
// To parse the JSON, add this file to your project and do:
//
//   let movie = try? newJSONDecoder().decode(Movie.self, from: jsonData)

//
// To read values from URLs:
//
//   let task = URLSession.shared.movieTask(with: url) { movie, response, error in
//     if let movie = movie {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - Movie
struct Movie: Codable {
	let adult: Bool
	let backdropPath: String
	let belongsToCollection: JSONNull?
	let budget: Int
	let genres: [Genre]
	let homepage: String
	let id: Int
	let imdbID, originalLanguage, originalTitle, overview: String
	let popularity: Double
	let posterPath: String
	let productionCompanies: [ProductionCompany]
	let productionCountries: [ProductionCountry]
	let releaseDate: String
	let revenue, runtime: Int
	let spokenLanguages: [SpokenLanguage]
	let status, tagline, title: String
	let video: Bool
	let voteAverage: Double
	let voteCount: Int

	enum CodingKeys: String, CodingKey {
		case adult
		case backdropPath = "backdrop_path"
		case belongsToCollection = "belongs_to_collection"
		case budget, genres, homepage, id
		case imdbID = "imdb_id"
		case originalLanguage = "original_language"
		case originalTitle = "original_title"
		case overview, popularity
		case posterPath = "poster_path"
		case productionCompanies = "production_companies"
		case productionCountries = "production_countries"
		case releaseDate = "release_date"
		case revenue, runtime
		case spokenLanguages = "spoken_languages"
		case status, tagline, title, video
		case voteAverage = "vote_average"
		case voteCount = "vote_count"
	}
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.genreTask(with: url) { genre, response, error in
//     if let genre = genre {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Genre
struct Genre: Codable {
	let id: Int
	let name: String
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.productionCompanyTask(with: url) { productionCompany, response, error in
//     if let productionCompany = productionCompany {
//       ...
//     }
//   }
//   task.resume()

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
	let id: Int
	let logoPath: String?
	let name, originCountry: String

	enum CodingKeys: String, CodingKey {
		case id
		case logoPath = "logo_path"
		case name
		case originCountry = "origin_country"
	}
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.productionCountryTask(with: url) { productionCountry, response, error in
//     if let productionCountry = productionCountry {
//       ...
//     }
//   }
//   task.resume()

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
	let iso3166_1, name: String

	enum CodingKeys: String, CodingKey {
		case iso3166_1 = "iso_3166_1"
		case name
	}
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.spokenLanguageTask(with: url) { spokenLanguage, response, error in
//     if let spokenLanguage = spokenLanguage {
//       ...
//     }
//   }
//   task.resume()

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
	let englishName, iso639_1, name: String

	enum CodingKeys: String, CodingKey {
		case englishName = "english_name"
		case iso639_1 = "iso_639_1"
		case name
	}
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
	let decoder = JSONDecoder()
	if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
		decoder.dateDecodingStrategy = .iso8601
	}
	return decoder
}

func newJSONEncoder() -> JSONEncoder {
	let encoder = JSONEncoder()
	if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
		encoder.dateEncodingStrategy = .iso8601
	}
	return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
	fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
		return self.dataTask(with: url) { data, response, error in
			guard let data = data, error == nil else {
				completionHandler(nil, response, error)
				return
			}
			completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
		}
	}

	func movieTask(with url: URL, completionHandler: @escaping (Movie?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
		return self.codableTask(with: url, completionHandler: completionHandler)
	}
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

	public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
		return true
	}

	public var hashValue: Int {
		return 0
	}

	public init() {}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if !container.decodeNil() {
			throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
		}
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encodeNil()
	}
}
