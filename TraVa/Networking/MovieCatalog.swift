//
//  MovieCatalog.swift
//  Networking
//
//  Created by Кирилл Прокофьев on 22.10.2026.
//

import Domain
import Foundation

/// OMDb не предоставляет подборок «Популярное» и «Скоро» (в отличие от TMDB),
/// поэтому их состав задаётся здесь:
/// - «Популярное» — курируемый список IMDb ID, по каждому загружается полная карточка;
/// - «Скоро» — поиск фильмов текущего года по набору поисковых слов.
public struct MovieCatalog {
    public let popularIDs: [Movie.ID]
    public let upcomingSearchTerms: [String]
    public let pageSize: Int

    public init(popularIDs: [Movie.ID], upcomingSearchTerms: [String], pageSize: Int) {
        self.popularIDs = popularIDs
        self.upcomingSearchTerms = upcomingSearchTerms
        self.pageSize = pageSize
    }
}

public extension MovieCatalog {
    static let `default` = MovieCatalog(
        popularIDs: [
            "tt15398776", // Oppenheimer
            "tt15239678", // Dune: Part Two
            "tt10872600", // Spider-Man: No Way Home
            "tt1160419", // Dune
            "tt6751668", // Parasite
            "tt4154796", // Avengers: Endgame
            "tt0816692", // Interstellar
            "tt1375666", // Inception
            "tt0468569", // The Dark Knight
            "tt0111161", // The Shawshank Redemption
            "tt0068646", // The Godfather
            "tt0133093", // The Matrix
            "tt0109830", // Forrest Gump
            "tt0137523", // Fight Club
            "tt0110912", // Pulp Fiction
            "tt0120737", // The Lord of the Rings: The Fellowship of the Ring
            "tt0167260", // The Lord of the Rings: The Return of the King
            "tt0114369", // Se7en
            "tt0102926", // The Silence of the Lambs
            "tt0245429" // Spirited Away
        ],
        upcomingSearchTerms: ["love", "man", "night"],
        pageSize: 10
    )
}
