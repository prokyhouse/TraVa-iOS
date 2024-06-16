//
//  PopularViewPresenter.swift
//  Presentation
//
//  Created by Кирилл Прокофьев on 27.03.2023.
//

import Foundation
import Networking
import Domain

public protocol PopularPresenter: AnyObject {
    /// Обработка перехода на экран фильма
    func showMovieDetails(_ id: Int)

    /// Получение новых фильмов
    func fetchPopularMovies()
}

public final class PopularViewPresenter {
    // MARK: - Private Properties

    private unowned let viewController: PopularViewController
    private let coordinator: TabBarCoordinator
    private let networkService: Networkable

    // MARK: - Initialization

    init(
        viewController: PopularViewController,
        coordinator: TabBarCoordinator,
        networkService: Networkable
    ) {
        self.viewController = viewController
        self.coordinator = coordinator
        self.networkService = networkService
    }
}

// MARK: - PopularPresenter

extension PopularViewPresenter: PopularPresenter {
    public func fetchPopularMovies() {
        networkService.fetchPopularMovies(page: 1) { [weak self] (result: Result<[Movie], Error>) in
            switch result {
                case .success(let movies):
                    DispatchQueue.main.async {
                        self?.viewController.setPopularMovies(movies)
                    }

                case .failure:
                    break
            }
        }
    }

    public func showMovieDetails(_ id: Int) {
        coordinator.goToMovieDetails(id)
    }
}

// MARK: - Private Methods

private extension PopularViewPresenter { }

// MARK: - Constants

private extension PopularViewPresenter {
    enum Constants { }
}
