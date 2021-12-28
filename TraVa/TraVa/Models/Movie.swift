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
struct Movie: Decodable {
	let adult: Bool
	let backdropPath: String?
	let belongsToCollection: BelongsToCollection?
	let budget: Int?
	let genres: [Genre]?
	let homepage: String?
	let id: Int
	let imdbID, originalLanguage, originalTitle, overview: String?
	let popularity: Double
	let posterPath: String
	let productionCompanies: [ProductionCompany]?
	let productionCountries: [ProductionCountry]?
	let releaseDate: String?
	let revenue, runtime: Int?
	let spokenLanguages: [SpokenLanguage]?
	let status, tagline, title: String?
	let video: Bool
	let voteAverage: Double
	let voteCount: Int
	let credits: Credits?

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
		case credits
	}
}

extension Movie {
	static var sampleData: [Self] {
		let movie = Movie(adult: false, backdropPath: "/1Rr5SrvHxMXHu5RjKpaMba8VTzi.jpg", belongsToCollection: nil, budget: nil, genres: nil, homepage: nil, id: 634649, imdbID: nil, originalLanguage: "en", originalTitle: "Spider-Man: No Way Home", overview: "Действие фильма «Человек-паук: Нет пути домой» начинает своё развитие в тот момент, когда Мистерио удаётся выяснить истинную личность Человека-паука. С этого момента жизнь Питера Паркера становится невыносимой. Если ранее он мог успешно переключаться между своими амплуа, то сейчас это сделать невозможно. Переворачивается с ног на голову не только жизнь Человека-пауку, но и репутация.  Понимая, что так жить невозможно, главный герой фильма «Человек-паук: Нет пути домой» принимает решение обратиться за помощью к своему давнему знакомому Стивену Стрэнджу. Питер Паркер надеется, что с помощью магии он сможет восстановить его анонимность. Стрэндж соглашается помочь.", popularity: 18227.93, posterPath: "/3hLU5V1XDF0oHT9YUHvYC4j0Ix5.jpg", productionCompanies: nil, productionCountries: nil, releaseDate: "2021-12-15", revenue: nil, runtime: nil, spokenLanguages: nil, status: nil, tagline: nil, title: "Человек-паук: Нет пути домой", video: false, voteAverage: 8.6, voteCount: 2025, credits: Credits(cast: [], crew: []))

		return [movie]
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

// MARK: - BelongsToCollection
struct BelongsToCollection: Codable {
	let id: Int?
	let name, posterPath, backdropPath: String?

	enum CodingKeys: String, CodingKey {
		case id, name
		case posterPath = "poster_path"
		case backdropPath = "backdrop_path"
	}
}

// MARK: - Credits
struct Credits: Codable {
	let cast, crew: [Cast]?
}


// MARK: - Cast
struct Cast: Codable {
	let adult: Bool?
	let gender, id: Int?
	let knownForDepartment: Department?
	let name, originalName: String?
	let popularity: Double?
	let profilePath: String?
	let castID: Int?
	let character: String?
	let creditID: String?
	let order: Int?
	let department: Department?
	let job: String?

	enum CodingKeys: String, CodingKey {
		case adult, gender, id
		case knownForDepartment = "known_for_department"
		case name
		case originalName = "original_name"
		case popularity
		case profilePath = "profile_path"
		case castID = "cast_id"
		case character
		case creditID = "credit_id"
		case order, department, job
	}
}

enum Department: String, Codable {
	case acting = "Acting"
	case art = "Art"
	case camera = "Camera"
	case costumeMakeUp = "Costume & Make-Up"
	case crew = "Crew"
	case directing = "Directing"
	case editing = "Editing"
	case production = "Production"
	case sound = "Sound"
	case visualEffects = "Visual Effects"
	case writing = "Writing"
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
