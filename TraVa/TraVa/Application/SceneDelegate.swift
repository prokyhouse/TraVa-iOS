//
//  SceneDelegate.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 22.12.2021.
//

import UIKit
import Presentation

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navController = UINavigationController()
        navController.isNavigationBarHidden = true
        coordinator = AppCoordinator(navigationController: navController)
        coordinator?.start()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}
