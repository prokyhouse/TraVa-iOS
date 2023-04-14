//
//  AppFont.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 31.03.2023.
//

import UIKit

public struct AppFont {
    // MARK: - Properties

    let name: String

    // MARK: - Functions

    public func ofSize(_ size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            assertionFailure("[AppFont] Unsuccessful attempt to create font. Font name - \"\(name)\"")
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}

extension AppFont: ExpressibleByStringLiteral {
    // MARK: - Initialization

    public init(stringLiteral value: String) {
        self.name = value
    }
}
