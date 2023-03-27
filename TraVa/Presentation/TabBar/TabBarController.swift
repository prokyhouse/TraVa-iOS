//
//  TabBarController.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 22.12.2021.
//

import DesignBook
import UIKit

public final class TabBarController: UITabBarController {
    // MARK: - Lifecycle

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    override public func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        delegate = self
    }
}

private extension TabBarController {
    func setupAppearance() {
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .systemBackground
        tabBar.unselectedItemTintColor = .gray
        tabBar.tintColor = UIColor(named: "AccentColor")
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    public func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        return true
    }
}
