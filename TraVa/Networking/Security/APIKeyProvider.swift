//
//  APIKeyProvider.swift
//  Networking
//
//  Created by Кирилл Прокофьев on 22.10.2026.
//

import Foundation

/// Источник API-ключа. Абстракция позволяет заменить вшитый ключ
/// на ключ, полученный с собственного бэкенда, без изменений в сетевом слое.
public protocol APIKeyProviding {
    func apiKey() throws -> String
}

/// Ключ, внедрённый на этапе сборки (Configs/Secrets.xcconfig → Scripts/generate-secrets.sh).
/// Ключ хранится в бинарнике в XOR-обфусцированном виде и восстанавливается
/// только в момент запроса, не оседая в статических свойствах.
struct BuildTimeAPIKeyProvider: APIKeyProviding {
    func apiKey() throws -> String {
        let bytes = zip(OMDbSecrets.obfuscatedAPIKey, OMDbSecrets.salt).map { $0 ^ $1 }
        guard !bytes.isEmpty else {
            throw NetworkError.missingAPIKey
        }
        return String(decoding: bytes, as: UTF8.self)
    }
}
