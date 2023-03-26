//
//  TabBarController.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 22.12.2021.
//

import Foundation
import UIKit

public final class TabBarController: UITabBarController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Private methods

private extension TabBarController {
    func setup() {
        let mainNavVC = makeMain()
        let popularNavVC = makePopular()
        let upcomingNavVC = makeUpcoming()
        viewControllers = [mainNavVC, popularNavVC, upcomingNavVC]
    }

    func makeMain() -> UINavigationController {
        let mainVC = MainViewController()
        mainVC.title = Constants.main.fullTitle
        mainVC.tabBarItem = createMainTab()

        return UINavigationController(rootViewController: mainVC)
    }

    func makePopular() -> UINavigationController {
        let popularVC = PopularViewController()
        popularVC.title = Constants.popular.fullTitle
        popularVC.tabBarItem = createPopularTab()

        return UINavigationController(rootViewController: popularVC)
    }

    func makeUpcoming() -> UINavigationController {
        let upcomingVC = UpcomingViewController()
        upcomingVC.title = Constants.upcoming.fullTitle
        upcomingVC.tabBarItem = createUpcomingTab()

        return UINavigationController(rootViewController: upcomingVC)
    }

    func createMainTab() -> UITabBarItem {
        let item = UITabBarItem(
            title: Constants.main.title,
            image: Constants.main.icon,
            tag: 0
        )
        return item
    }

    func createPopularTab() -> UITabBarItem {
        let item = UITabBarItem(
            title: Constants.popular.title,
            image: Constants.popular.icon,
            tag: 1
        )
        return item
    }

    func createUpcomingTab() -> UITabBarItem {
        let item = UITabBarItem(
            title: Constants.upcoming.title,
            image: Constants.upcoming.icon,
            tag: 2
        )
        return item
    }
}

// MARK: - Constants

private extension TabBarController {
    enum Constants {
        static let main: TabSection = .init(
            title: "Главная",
            fullTitle: "Главная",
            icon: UIImage(systemName: "house.fill")
        )
        static let popular: TabSection = .init(
            title: "Популярное",
            fullTitle: "Популярно сейчас",
            icon: UIImage(systemName: "hand.thumbsup.fill")
        )
        static let upcoming: TabSection = .init(
            title: "Скоро",
            fullTitle: "Скоро в кино",
            icon: UIImage(systemName: "hourglass")
        )
    }
}

// MARK: - TabSection

private struct TabSection {
    let title: String
    let fullTitle: String
    let icon: UIImage?
}
