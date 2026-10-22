//
//  NetworkError.swift
//  Networking
//
//  Created by Кирилл Прокофьев on 22.10.2026.
//

import Foundation

public enum NetworkError: LocalizedError {
    /// Ключ OMDb не задан при сборке (см. Configs/Secrets.xcconfig.example)
    case missingAPIKey

    /// OMDb вернул `"Response": "False"` (неверный ключ, превышен лимит, фильм не найден…)
    case api(message: String)

    /// Ответ не удалось разобрать
    case decoding(Error)

    /// Ошибка транспорта (нет сети, таймаут и т.д.)
    case transport(Error)

    public var errorDescription: String? {
        switch self {
            case .missingAPIKey:
                return "OMDb API key is missing"

            case let .api(message):
                return message

            case let .decoding(error):
                return "Decoding failed: \(error.localizedDescription)"

            case let .transport(error):
                return error.localizedDescription
        }
    }
}
