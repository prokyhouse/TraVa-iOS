//
//  BaseNavigationCoordinator.swift
//  Common
//
//  Created by Кирилл Прокофьев on 01.03.2023.
//

import UIKit

open class BaseNavigationCoordinator: Coordinator {
    // MARK: - Properties
    private var _children: [Coordinator] = []

    public let navigationController: UINavigationController

    // MARK: - Coordinator Properties
    public var rootViewController: UIViewController {
        navigationController
    }

    public var children: [Coordinator] {
        _children
    }

    // MARK: - Lifecycle
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        print("🚀✅ Coordinator inited: \(String(describing: self)) [\(Unmanaged.passUnretained(self).toOpaque())]")
    }

    deinit {
        _children.removeAll()
        print("🚀❎ Coordinator deinited: \(String(describing: self)) [\(Unmanaged.passUnretained(self).toOpaque())]")
    }

    // MARK: - Methods
    public func add(child coordinator: Coordinator) {
        _children.append(coordinator)
    }

    public func remove(child coordinator: Coordinator) {
        _children = _children.filter { coordinator !== $0 }
    }

    // MARK: - Coordinator Methods
    open func start() {
        fatalError("this method must be overridden")
    }
}
