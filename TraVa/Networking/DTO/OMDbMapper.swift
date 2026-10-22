//
//  OMDbMapper.swift
//  Networking
//
//  Created by Кирилл Прокофьев on 22.10.2026.
//

import Domain
import Foundation

/// Преобразование ответов OMDb в доменные модели.
/// Всё знание о формате OMDb ("N/A", числа строками, списки через запятую) живёт здесь.
enum OMDbMapper {
    static func movie(from dto: OMDbMovieDTO) -> Movie {
        let title = dto.title.omdbValue

        return Movie(
            id: dto.imdbID,
            title: title,
            year: dto.year.omdbValue,
            releaseDate: dto.released.omdbValue,
            overview: dto.plot.omdbValue,
            posterURL: posterURL(from: dto.poster, width: Constants.posterWidth),
            largePosterURL: posterURL(from: dto.poster, width: Constants.largePosterWidth),
            backdropURL: nil,
            voteAverage: dto.imdbRating.omdbValue.flatMap(Double.init),
            voteCount: dto.imdbVotes.omdbValue.flatMap { Int($0.replacingOccurrences(of: ",", with: "")) },
            runtime: dto.runtime.omdbValue.flatMap { Int($0.prefix { $0.isNumber }) },
            genres: list(from: dto.genre),
            ratings: (dto.ratings ?? []).map { Rating(source: $0.source, value: $0.value) },
            type: dto.type.omdbValue.flatMap(MediaType.init(rawValue:)),
            credits: Credits(
                cast: list(from: dto.actors).map {
                    Cast(name: $0, department: .acting, movieTitle: title)
                },
                crew: crew(from: dto.director, department: .directing, movieTitle: title)
                    + crew(from: dto.writer, department: .writing, movieTitle: title)
            )
        )
    }

    static func movie(from dto: OMDbSearchItemDTO) -> Movie {
        Movie(
            id: dto.imdbID,
            title: dto.title.omdbValue,
            year: dto.year.omdbValue,
            posterURL: posterURL(from: dto.poster, width: Constants.posterWidth),
            largePosterURL: posterURL(from: dto.poster, width: Constants.largePosterWidth),
            type: dto.type.omdbValue.flatMap(MediaType.init(rawValue:))
        )
    }
}

// MARK: - Private Methods

private extension OMDbMapper {
    /// OMDb отдаёт постеры Amazon вида `...@._V1_SX300.jpg`.
    /// Суффикс `SX<ширина>` задаёт ширину картинки — подменяем его, чтобы получить нужное качество.
    static func posterURL(from value: String?, width: Int) -> URL? {
        guard let value = value.omdbValue else { return nil }

        let resized = value.replacingOccurrences(
            of: #"_SX\d+"#,
            with: "_SX\(width)",
            options: .regularExpression
        )
        return URL(string: resized)
    }

    static func list(from value: String?) -> [String] {
        guard let value = value.omdbValue else { return [] }

        return value
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    /// `"Stephen King (short story), Frank Darabont (screenplay)"` → имя + уточнение роли
    static func crew(from value: String?, department: Department, movieTitle: String?) -> [Cast] {
        list(from: value).map { item in
            guard let bracket = item.firstIndex(of: "(") else {
                return Cast(name: item, department: department, movieTitle: movieTitle)
            }

            let name = item[..<bracket].trimmingCharacters(in: .whitespaces)
            let job = item[bracket...].trimmingCharacters(in: CharacterSet(charactersIn: "() "))
            return Cast(name: name, department: department, job: job, movieTitle: movieTitle)
        }
    }
}

// MARK: - Constants

private extension OMDbMapper {
    enum Constants {
        static let posterWidth = 600
        static let largePosterWidth = 1200
    }
}

// MARK: - N/A

private extension Optional where Wrapped == String {
    /// OMDb использует `"N/A"` вместо `null` для отсутствующих значений
    var omdbValue: String? {
        guard let value = self?.trimmingCharacters(in: .whitespaces),
              !value.isEmpty,
              value != "N/A"
        else {
            return nil
        }
        return value
    }
}
