//
//  TabBarController.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 22.12.2021.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()
		self.set()
	}

	func set() {
		let viewControllers: [UIViewController]
		let mainVC = MainViewController()
		mainVC.title = "Главная"
		let mainNavVC = UINavigationController(rootViewController: mainVC)
		mainVC.tabBarItem = self.createMainTab()

		let popularVC = PopularViewController()
		popularVC.title = "Популярное"
		let popularNavVC = UINavigationController(rootViewController: popularVC)
		popularVC.tabBarItem = self.createPopularTab()

		let upcomingVC = UpcomingViewController()
		upcomingVC.title = "Скоро в кино"
		let upcomingNavVC = UINavigationController(rootViewController: upcomingVC)
		upcomingVC.tabBarItem = self.createUpcomingTab()

		viewControllers = [mainNavVC,popularNavVC, upcomingNavVC]
		self.viewControllers = viewControllers
	}

	func createMainTab() -> UITabBarItem {
		let item = UITabBarItem(title: "Главная", image: UIImage(systemName: "house.fill"), tag: 0)
		return item
	}

	func createPopularTab() -> UITabBarItem {
		let item = UITabBarItem(title: "Популярное", image: UIImage(systemName: "hand.thumbsup.fill"), tag: 1)
		return item
	}

	func createUpcomingTab() -> UITabBarItem {
		let item = UITabBarItem(title: "Скоро", image: UIImage(systemName: "hourglass"), tag: 2)
		return item
	}
}
