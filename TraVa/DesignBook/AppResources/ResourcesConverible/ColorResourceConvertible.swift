//
//  ColorResourceConvertible.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 31.03.2023.
//

import UIKit

public protocol ColorResourceConvertible: ResourceConvertible {}

public extension ColorResourceConvertible {
    func get() -> UIColor {
        return UIColor(hexString: rawValue)
    }
}
