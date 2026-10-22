//
//  Movie.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import Foundation

// MARK: - Movie

/// Фильм (или сериал) в доменном представлении — не зависит от конкретного API.
public struct Movie: Identifiable, Equatable {
    /// Идентификатор фильма в IMDb (например, `tt0111161`)
    public typealias ID = String

    public let id: ID
    public let title: String?
    public let year: String?
    public let releaseDate: String?
    public let overview: String?
    public let posterURL: URL?
    public let largePosterURL: URL?
    public let backdropURL: URL?
    public let voteAverage: Double?
    public let voteCount: Int?
    public let runtime: Int?
    public let genres: [String]
    public let ratings: [Rating]
    public let type: MediaType?
    public let credits: Credits?

    public init(
        id: ID,
        title: String?,
        year: String? = nil,
        releaseDate: String? = nil,
        overview: String? = nil,
        posterURL: URL? = nil,
        largePosterURL: URL? = nil,
        backdropURL: URL? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil,
        runtime: Int? = nil,
        genres: [String] = [],
        ratings: [Rating] = [],
        type: MediaType? = nil,
        credits: Credits? = nil
    ) {
        self.id = id
        self.title = title
        self.year = year
        self.releaseDate = releaseDate
        self.overview = overview
        self.posterURL = posterURL
        self.largePosterURL = largePosterURL
        self.backdropURL = backdropURL
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.runtime = runtime
        self.genres = genres
        self.ratings = ratings
        self.type = type
        self.credits = credits
    }
}

public extension Movie {
    static var sampleData: [Self] {
        let movie = Movie(
            id: "tt10872600",
            title: "Человек-паук: Нет пути домой",
            year: "2021",
            releaseDate: "17 Dec 2021",
            overview: "Действие фильма «Человек-паук: Нет пути домой» начинает своё развитие в тот момент, когда Мистерио удаётся выяснить истинную личность Человека-паука. С этого момента жизнь Питера Паркера становится невыносимой. Если ранее он мог успешно переключаться между своими амплуа, то сейчас это сделать невозможно. Переворачивается с ног на голову не только жизнь Человека-пауку, но и репутация.  Понимая, что так жить невозможно, главный герой фильма «Человек-паук: Нет пути домой» принимает решение обратиться за помощью к своему давнему знакомому Стивену Стрэнджу. Питер Паркер надеется, что с помощью магии он сможет восстановить его анонимность. Стрэндж соглашается помочь.",
            voteAverage: 8.2,
            voteCount: 900_000,
            runtime: 148,
            genres: ["Action", "Adventure", "Fantasy"],
            type: .movie,
            credits: Credits(cast: [], crew: [])
        )

        return [movie]
    }
}

// MARK: - MediaType

public enum MediaType: String {
    case movie
    case series
    case episode
}

// MARK: - Rating

/// Оценка из внешнего источника (IMDb, Rotten Tomatoes, Metacritic и т.д.)
public struct Rating: Equatable {
    public let source: String
    public let value: String

    public init(source: String, value: String) {
        self.source = source
        self.value = value
    }
}

// MARK: - Credits

public struct Credits: Equatable {
    public let cast, crew: [Cast]?

    public init(cast: [Cast]?, crew: [Cast]?) {
        self.cast = cast
        self.crew = crew
    }
}

// MARK: - Cast

public struct Cast: Equatable {
    public let name: String?
    public let profileURL: URL?
    public let gender: Gender?
    public let character: String?
    public let department: Department?
    public let job: String?
    /// Название фильма, в карточке которого указан участник
    public let movieTitle: String?

    public init(
        name: String?,
        profileURL: URL? = nil,
        gender: Gender? = nil,
        character: String? = nil,
        department: Department? = nil,
        job: String? = nil,
        movieTitle: String? = nil
    ) {
        self.name = name
        self.profileURL = profileURL
        self.gender = gender
        self.character = character
        self.department = department
        self.job = job
        self.movieTitle = movieTitle
    }
}

public enum Department: String {
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

    public func asString() -> String {
        switch self {
            case .acting:
                return "Актёр"

            case .directing:
                return "Режиссёр"

            case .writing:
                return "Сценарист"

            case .production:
                return "Продюсер"

            default:
                return rawValue
        }
    }
}
