//
//  ViewController.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 22.12.2021.
//

import Domain
import Networking
import UIKit

public final class MainViewController: UIViewController, MainViewDelegate {
    func pushVC(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private var mainView: MainView = MainView()
    private let networkService: Networkable = NetworkService()
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
}

// MARK: - Private methods

private extension MainViewController {
    func loadData() {
        networkService.fetchPopularMovies(page: 1){ [weak self] (result: Result<[Movie], Error>) in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.mainView.setPopularMovies(popularMovies: movies)
                    self?.mainView.popularCollectionView.reloadData()
                }

            case .failure(_):
                break
            }
        }

        networkService.fetchUpcomingMovies(page: 1){ [weak self] (result: Result<[Movie], Error>) in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.mainView.setUpcomingMovies(upcomingMovies: movies)
                    self?.mainView.upcomingCollectionView.reloadData()
                }

            case .failure(_):
                break
            }
        }
    }
}

// MARK: - Constants

private extension MainViewController {
    enum Constants {
        static let errorDescription: String = "Загрузка закончена с ошибкой"
    }
}
