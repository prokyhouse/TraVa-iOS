//
//  MovieViewPresenter.swift
//  Presentation
//
//  Created by Кирилл Прокофьев on 27.03.2023.
//

import Foundation
import Networking
import Domain

public protocol MoviePresenter: AnyObject {
    /// Обработка перехода на экран актёра
    func showActor(_ actor: Cast)

    /// Получение фильма
    func fetchMovie()

    /// Переход назад
    func handleBackTap()
}

public final class MovieViewPresenter {
    // MARK: - Private Properties

    private unowned let viewController: MovieViewController
    private let coordinator: TabBarCoordinator
    private let networkService: Networkable
    private let movieID: Int

    // MARK: - Initialization

    init(
        viewController: MovieViewController,
        coordinator: TabBarCoordinator,
        networkService: Networkable,
        movieID: Int
    ) {
        self.viewController = viewController
        self.coordinator = coordinator
        self.networkService = networkService
        self.movieID = movieID
    }
}

// MARK: - MoviePresenter

extension MovieViewPresenter: MoviePresenter {
    public func handleBackTap() {
        coordinator.goBack()
    }

    public func fetchMovie() {
        networkService.fetchMovie(movie: movieID) { [weak self] (result: Result<Movie, Error>) in
            switch result {
                case .success(let movie):
                    DispatchQueue.main.async {
                        self?.viewController.setMovie(movie)
                    }

                case .failure:
                    break
            }
        }
    }

    public func showActor(_ actor: Cast) {
        coordinator.goToActorDetails(actor)
    }
}

// MARK: - Private Methods

private extension MovieViewPresenter { }

// MARK: - Constants

private extension MovieViewPresenter {
    enum Constants { }
}
