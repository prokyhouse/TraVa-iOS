//
//  AppResources.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 30.03.2023.
//

import Foundation

public final class AppResources {
    // MARK: - Properties

    public static let bundle: Bundle = {
        Bundle(for: AppResources.self)
    }()

    /// Менеджер цветов.
    public static let colors: AppColors = .init()

    /// Менеджер шрифтов.
    public static let fonts: AppFonts = .init()

    /// Менеджер изображений и иконок.
    // public static let images: AppImages = .init()

    /// Менеджер цветовой темы приложения.
    public static let appearance: AppAppearance = .init()

    /// Локализованные строки.
    // public static let localization = AppLocalization.self
}
