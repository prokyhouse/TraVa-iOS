//
//  TabBarPage.swift
//
//  Created by Кирилл Прокофьев on 21.03.2023.
//

import DesignBook
import UIKit

public enum TabBarPage: Int, CaseIterable {
    case main = 0
    case popular = 1
    case upcoming = 2

    public func getTitle(full: Bool = false) -> String {
        return full ? fullTitle : title
    }

    public func getIcon(for state: TabBarPageState) -> UIImage? {
        switch state {
            case .selected:
                return selectedIcon

            case .unselected:
                return unselectedIcon
        }
    }
}

// MARK: - Properties

private extension TabBarPage {
    var title: String {
        switch self {
            case .main:
                return "Главная"

            case .popular:
                return "Популярное"

            case .upcoming:
                return "Скоро"
        }
    }

    var fullTitle: String {
        switch self {
            case .main:
                return "Главная"

            case .popular:
                return "Популярно сейчас"

            case .upcoming:
                return "Скоро доступно"
        }
    }

    var unselectedIcon: UIImage? {
        switch self {
            case .main:
                return UIImage(systemName: "house")

            case .popular:
                return UIImage(systemName: "hand.thumbsup")

            case .upcoming:
                return UIImage(systemName: "hourglass.bottomhalf.filled")
        }
    }

    var selectedIcon: UIImage? {
        switch self {
            case .main:
                return UIImage(systemName: "house.fill")

            case .popular:
                return UIImage(systemName: "hand.thumbsup.fill")

            case .upcoming:
                return UIImage(systemName: "hourglass.tophalf.filled")
        }
    }
}
