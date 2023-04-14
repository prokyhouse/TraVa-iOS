//
//  AppFonts.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 31.03.2023.
//

import CoreText
import UIKit
import Foundation

/// Менеджер шрифтов.
public class AppFonts: NSObject {
    // MARK: - Properties

    /// Source Sans Pro
    public let ssPro: SourceSansProFonts = .init()

    // MARK: - Initialization

    override internal init() {
        super.init()

        [
            "SourceSansPro-Bold",
            "SourceSansPro-SemiBold",
            "SourceSansPro-Regular",
            "SourceSansPro-Light",
        ]
            .forEach { appFont in
                AppFonts.loadFont(withName: appFont)
            }
    }

    // MARK: - Methods

    private static func loadFont(withName fontName: String) {
        let bundle = Bundle(for: AppFonts.self)
        let fontExtension = "ttf"
        guard
            let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension)
        else {
            return
        }
        CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
    }
}

