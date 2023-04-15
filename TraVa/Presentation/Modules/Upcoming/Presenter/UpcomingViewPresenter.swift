//
//  UpcomingViewPresenter.swift
//  Presentation
//
//  Created by Кирилл Прокофьев on 27.03.2023.
//

import Foundation
import Networking
import Domain

public protocol UpcomingPresenter: AnyObject {
    /// Обработка перехода на экран фильма
    func showMovieDetails(_ id: Int)

    /// Получение новых фильмов
    func fetchUpcomingMovies()
}

public final class UpcomingViewPresenter {
    // MARK: - Private Properties

    private unowned let viewController: UpcomingViewController
    private let coordinator: TabBarCoordinator
    private let networkService: Networkable

    // MARK: - Initialization

    init(
        viewController: UpcomingViewController,
        coordinator: TabBarCoordinator,
        networkService: Networkable
    ) {
        self.viewController = viewController
        self.coordinator = coordinator
        self.networkService = networkService
    }
}

// MARK: - UpcomingPresenter

extension UpcomingViewPresenter: UpcomingPresenter {
    public func fetchUpcomingMovies() {
        networkService.fetchUpcomingMovies(page: 1){ [weak self] (result: Result<[Movie], Error>) in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self?.viewController.setUpcomingMovies(movies)
                }

            case .failure(_):
                self?.showNetworkError()
            }
        }
    }

    public func showMovieDetails(_ id: Int) {
        coordinator.goToMovieDetails(id)
    }
}

// MARK: - Private Methods

private extension UpcomingViewPresenter {
    func showNetworkError() {
        viewController.displayNetworkError()

        let isVPN: Bool = networkService.isVPN
        let fromRussia: Bool = Locale.current.languageCode == "ru"
        if !isVPN && fromRussia {
            viewController.showDialog(
                with: .init(
                    title: Constants.VPNDialog.title,
                    subtitle: Constants.VPNDialog.subtitle,
                    buttons: [
                        .init(
                            text: "Настройки",
                            style: .filled,
                            action: coordinator.openSettings
                        )
                    ]
                )
            )
        } else {
            viewController.showMessage(
                with: .error(text: "При загрузке контента произошла ошибка. Попробуйте позднее.")
            )
        }
    }
}

// MARK: - Constants

private extension UpcomingViewPresenter {
    enum Constants {
        enum VPNDialog {
            static let title: String = "Пожалуйста, включите VPN."
            static let subtitle: String = "К сожалению, сервис TMDB, предоставляющий контент, перестал работать на территории России."
            static let buttonTitle: String = "Настройки"
        }
    }
}

