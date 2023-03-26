//
//  Gender.swift
//  Domain
//
//  Created by Кирилл Прокофьев on 20.03.2023.
//

import Foundation

public enum Gender: Int, Codable {
    case male = 2
    case female = 1
    case unknown = 0

    public func asString() -> String {
        switch self {
        case .male:
            return "Мужской"

        case .female:
            return "Женский"

        case .unknown:
            return "Неизвестно"
        }
    }
}
