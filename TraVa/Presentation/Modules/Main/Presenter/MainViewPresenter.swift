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
    
    public func fetchPopularMovies() {
        networkService.fetchPopularMovies(page: 1 ){ [weak self] (result: Result<[Movie], Error>) in
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
    
    public func fetchUpcomingMovies() {
        networkService.fetchUpcomingMovies(page: 1) { [weak self] (result: Result<[Movie], Error>) in
            switch result {
                case .success(let movies):
                    DispatchQueue.main.async {
                        self?.viewController.setUpcomingMovies(movies)
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

private extension MainViewPresenter { }

// MARK: - Constants

private extension MainViewPresenter {
    enum Constants { }
}
