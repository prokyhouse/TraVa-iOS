//
//  SceneDelegate.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 22.12.2021.
//

import UIKit
import Presentation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		if let scene = scene as? UIWindowScene {
			let window = UIWindow(windowScene: scene)
			window.rootViewController = TabBarController()
			self.window = window
			self.window?.makeKeyAndVisible()
		}
	}
}
