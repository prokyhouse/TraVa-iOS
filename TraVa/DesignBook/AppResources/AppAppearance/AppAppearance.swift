//
//  AppAppearance.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 30.03.2023.
//

import UIKit

public final class AppAppearance {
    private let defaults = UserDefaults.standard
    private let defaultsKey: String = "AppAppearance"

    public init() {
        let appearance = getCurrent()
        change(to: appearance)
    }

    public func change(to appearance: UIUserInterfaceStyle) {
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = appearance
        }
        defaults.setValue(appearance.rawValue, forKeyPath: defaultsKey)
    }

    public func getCurrent() -> UIUserInterfaceStyle {
        if
            let storagedAppearanceAsInt = defaults.object(forKey: defaultsKey) as? Int,
            let storagedAppearance = UIUserInterfaceStyle(rawValue: storagedAppearanceAsInt)
        {
            return storagedAppearance
        } else {
            return UIUserInterfaceStyle.unspecified
        }
    }
}
