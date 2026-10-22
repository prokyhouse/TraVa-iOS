//
//  APIKeyPlugin.swift
//  Networking
//
//  Created by Кирилл Прокофьев on 22.10.2026.
//

import Foundation
import Moya

/// Добавляет `apikey` в query непосредственно перед отправкой запроса.
/// Благодаря этому ключ не является частью `MovieAPI` (TargetType),
/// а значит, не попадает в описания таргетов, логи и sampleData.
///
/// Важно: не подключайте `NetworkLoggerPlugin` без маскирования `apikey` —
/// OMDb принимает ключ только в query, и он окажется в логе вместе с URL.
struct APIKeyPlugin: PluginType {
    private let keyProvider: APIKeyProviding

    init(keyProvider: APIKeyProviding) {
        self.keyProvider = keyProvider
    }

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard
            let key = try? keyProvider.apiKey(),
            let url = request.url,
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            return request
        }

        var queryItems = components.queryItems ?? []
        queryItems.append(URLQueryItem(name: Constants.apiKeyParameter, value: key))
        components.queryItems = queryItems

        var request = request
        request.url = components.url
        return request
    }
}

// MARK: - Constants

private extension APIKeyPlugin {
    enum Constants {
        static let apiKeyParameter = "apikey"
    }
}
