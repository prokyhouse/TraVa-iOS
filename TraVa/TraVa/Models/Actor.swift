//
//  Actor.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import Foundation

class Actor {
	var actorName: String
	var actorCharacter: String
	var actorProfilePath: String
	var actorID: String

	init(_ actorID: String, _ actorName: String, _ actorCharacter: String, _ actorProfilePath: String) {
		self.actorName = actorName
		self.actorCharacter = actorCharacter
		self.actorProfilePath = actorProfilePath
		self.actorID = actorID
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
