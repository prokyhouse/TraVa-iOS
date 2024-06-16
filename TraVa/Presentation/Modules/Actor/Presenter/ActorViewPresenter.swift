//
//  ActorViewPresenter.swift
//  Presentation
//
//  Created by Кирилл Прокофьев on 27.03.2023.
//

import Foundation
import Networking
import Domain

public protocol ActorPresenter: AnyObject {
    /// Переход назад
    func handleBackTap()

    /// Получение/загрузка актёра
    func fetchActor()
}

public final class ActorViewPresenter {
    // MARK: - Private Properties

    private unowned let viewController: ActorViewController
    private let coordinator: TabBarCoordinator
    private var actor: Cast

    // MARK: - Initialization

    init(
        viewController: ActorViewController,
        coordinator: TabBarCoordinator,
        actor: Cast
    ) {
        self.viewController = viewController
        self.coordinator = coordinator
        self.actor = actor
    }
}

// MARK: - ActorPresenter

extension ActorViewPresenter: ActorPresenter {
    public func handleBackTap() {
        coordinator.goBack()
    }

    public func fetchActor() {
        viewController.setActor(actor)
    }
}

// MARK: - Private Methods

private extension ActorViewPresenter { }

// MARK: - Constants

private extension ActorViewPresenter {
    enum Constants { }
}
