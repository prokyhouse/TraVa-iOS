//
//  UIColor+Appearance.swift
//  Common
//
//  Created by Кирилл Прокофьев on 31.03.2023.
//

import UIKit

public extension UIColor {
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return light }
        return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }
}
