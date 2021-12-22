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
		viewControllers = [mainNavVC]
		self.viewControllers = viewControllers
	}

	func createMainTab() -> UITabBarItem {
		let item = UITabBarItem(title: "Главная", image: UIImage(systemName: "house.fill"), tag: 0)
		return item
	}
}
