//
//  AppColors.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 31.03.2023.
//

import UIKit

public struct AppColors {
    // MARK: - Colors

    public let accent: UIColor
    public let background: UIColor
    public let cell: UIColor
    public let error: UIColor
    public let inactive: UIColor
    public let overlay: UIColor
    public let second: UIColor
    public let text: UIColor
    public let textOnSecond: UIColor
    public let warning: UIColor

    // MARK: - Color Assets

    /// 9C27B0
    private let purple: UIColor = AppColor(rawValue: "#9C27B0").get()
    /// D376E3
    private let lightPurple: UIColor = AppColor(rawValue: "#D376E3").get()
    /// 53155E
    private let darkPurple: UIColor = AppColor(rawValue: "#53155E").get()
    /// 58315E
    private let darkestPurple: UIColor = AppColor(rawValue: "#58315E").get()
    /// FFFFFF
    private let white: UIColor = AppColor(rawValue: "#FFFFFF").get()
    /// 000000
    private let black: UIColor = AppColor(rawValue: "#000000").get()
    /// D9C8E3
    private let lightGray: UIColor = AppColor(rawValue: "#D9C8E3").get()
    /// 9875AC
    private let darkGray: UIColor = AppColor(rawValue: "#9875AC").get()
    /// D6150D
    private let red: UIColor = AppColor(rawValue: "#D6150D").get()
    /// ED791A
    private let orange: UIColor = AppColor(rawValue: "#ED791A").get()


    // MARK: - Initialization

    internal init() {
        accent = .dynamicColor(light: purple, dark: lightPurple)
        background = .dynamicColor(light: white, dark: darkestPurple)
        cell = .dynamicColor(light: lightGray, dark: darkGray)
        error = .dynamicColor(light: red, dark: red)
        inactive = .dynamicColor(light: lightGray, dark: darkGray)
        overlay = .dynamicColor(
            light: black.withAlphaComponent(0.8),
            dark: black.withAlphaComponent(0.7)
        )
        second = .dynamicColor(light: purple, dark: darkPurple)
        text = .dynamicColor(light: black, dark: white)
        textOnSecond = .dynamicColor(light: white, dark: white)
        warning = .dynamicColor(light: orange, dark: orange)
    }
}

// MARK: - Private Functions

private extension AppColors {
    private static func colorWithAlpha(forHexString hexString: String, alpha: Double) -> AppColor {
        guard
            !hexString.isEmpty
        else {
            return AppColor(rawValue: hexString)
        }

        let alphaPrefix = prefixString(forAlpha: alpha)

        var copy = hexString

        if copy.first == "#" {
            copy.removeFirst()
        }
        return AppColor(rawValue: "#\(alphaPrefix)\(copy)")
    }

    private static func prefixString(forAlpha alpha: Double) -> String {
        let fixedAlpha = min(max(alpha, 0), 1)
        let byteValue = Int(255 * fixedAlpha)
        return String(format: "%02X", byteValue)
    }
}
