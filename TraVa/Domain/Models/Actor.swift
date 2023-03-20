//
//  Actor.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import Foundation

public class Actor {
    var gender: Gender?
    var actorName: String?
    var actorCharacter: String?
    var actorProfilePath: String?
    var actorID: String?
    var imdbID: String?

    public init(
        _ gender: Gender,
        _ imdbID: String,
        _ actorID: String,
        _ actorName: String,
        _ actorCharacter: String,
        _ actorProfilePath: String
    ) {
        self.gender = gender
        self.imdbID = imdbID
        self.actorName = actorName
        self.actorCharacter = actorCharacter
        self.actorProfilePath = actorProfilePath
        self.actorID = actorID
    }

    enum CodingKeys: String, CodingKey {
        case imdbID = "imbd_id"
    }

    func getImdbID() -> String? {
        return self.imdbID
    }

    func getActorID() -> String? {
        return self.actorID
    }

    func getActorName() -> String? {
        return self.actorName
    }

    func getActorCharacter() -> String? {
        return self.actorCharacter
    }

    func getActorProfilePath() -> String? {
        return self.actorProfilePath
    }
}
