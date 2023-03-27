//
//  AppCoordinator.swift
//  Presentation
//
//  Created by Кирилл Прокофьев on 27.03.2023.
//

import Common
import Domain
import UIKit

public final class AppCoordinator: BaseNavigationCoordinator {
    // MARK: - Lifecycle

    override public func start() {
        goToGeneralFlow()
    }

    // MARK: - Flows

    public func goToGeneralFlow() {
        let coordinator = TabBarCoordinator(navigationController: navigationController)
        add(child: coordinator)
        coordinator.start()

        coordinator.onCompleted = { [weak self, weak coordinator] in
            if let coordinator = coordinator {
                self?.remove(child: coordinator)
            }
        }
    }
}
