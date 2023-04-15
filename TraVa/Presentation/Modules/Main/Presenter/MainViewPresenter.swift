//
//  MainViewPresenter.swift
//  Presentation
//
//  Created by Кирилл Прокофьев on 27.03.2023.
//

import Foundation
import Networking
import Domain

public protocol MainPresenter: AnyObject {
    /// Обработка перехода в "Популярное"
    func showPopular()

    /// Обработка перехода в "Скоро"
    func showUpcoming()

    /// Обработка перехода на экран фильма
    func showMovieDetails(_ id: Int)

    /// Получение популярных фильмов
    func fetchPopularMovies()

    /// Получение новых фильмов
    func fetchUpcomingMovies()
}

public final class MainViewPresenter {
    // MARK: - Private Properties

    private unowned let viewController: MainViewController
    private let coordinator: TabBarCoordinator
    private let networkService: Networkable

    // MARK: - Initialization

    init(
        viewController: MainViewController,
        coordinator: TabBarCoordinator,
        networkService: Networkable
    ) {
        self.viewController = viewController
        self.coordinator = coordinator
        self.networkService = networkService
    }
}

// MARK: - MainPresenter

extension MainViewPresenter: MainPresenter {
    public func showPopular() {
        coordinator.goToPopular()
    }

    public func showUpcoming() {
        coordinator.goToUpcoming()
    }

    public func fetchPopularMovies(){
        networkService.fetchPopularMovies(page: 1){ [weak self] (result: Result<[Movie], Error>) in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self?.viewController.setPopularMovies(movies)
                    self?.showNetworkError()
                }

            case .failure(let error):
                self?.showNetworkError()
            }
        }
    }

    public func fetchUpcomingMovies() {
        networkService.fetchUpcomingMovies(page: 1){ [weak self] (result: Result<[Movie], Error>) in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self?.viewController.setUpcomingMovies(movies)
                    self?.showNetworkError()
                }

            case .failure(let error):
                self?.showNetworkError()
            }
        }
    }

    public func showMovieDetails(_ id: Int) {
        coordinator.goToMovieDetails(id)
    }
}

// MARK: - Private Methods

private extension MainViewPresenter {
    func showNetworkError() {
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

private extension MainViewPresenter {
    enum Constants {
        enum VPNDialog {
            static let title: String = "Пожалуйста, включите VPN."
            static let subtitle: String = "К сожалению, сервис TMDB, предоставляющий контент, перестал работать на территории России."
            static let buttonTitle: String = "Настройки"
        }
    }
}

