//
//  ViewController.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 22.12.2021.
//

import Domain
import Networking
import UIKit

public final class MainViewController: UIViewController {
    var presenter: MainViewPresenter?
    private var mainView: MainView = MainView()
    private var movies: [Movie]?

    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?
            .navigationBar
            .titleTextAttributes = [
                .foregroundColor: UIColor(named: "AccentColor") ?? .systemPurple
            ]
    }

    public override func loadView() {
        loadData()
        mainView.delegate = self
        view = mainView
        view.backgroundColor = UIColor.systemBackground
    }

    // MARK: - Public methods

    func setPopularMovies(_ movies: [Movie]) {
        mainView.setPopularMovies(popularMovies: movies)
        mainView.popularCollectionView.reloadData()
    }

    func setUpcomingMovies(_ movies: [Movie]) {
        mainView.setUpcomingMovies(upcomingMovies: movies)
        mainView.upcomingCollectionView.reloadData()
    }
}

// MARK: - Private methods

private extension MainViewController {
    func loadData() {
        presenter?.fetchPopularMovies()
        presenter?.fetchUpcomingMovies()
    }
}

extension MainViewController: MainViewDelegate {
    func onPopularSectionTap() {
        presenter?.showPopular()
    }

    func onUpcomingSectionTap() {
        presenter?.showUpcoming()
    }

    func onMovieTap(with id: Int) {
        presenter?.showMovieDetails(id)
    }
}

// MARK: - Constants

private extension MainViewController {
    enum Constants {
        static let errorDescription: String = "Загрузка закончена с ошибкой"
    }
}
