//
//  ViewController.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 22.12.2021.
//

import UIKit

public final class MainViewController: UIViewController, MainViewDelegate {
    func pushVC(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private var mainView: MainView = MainView()
    private let networkService = NetworkService()
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
        networkService.loadData { [weak self] (result: Result<MoviesPage, Error>) in
            switch result {
            case .success(let model):
                print("[NETWORK] model is: \(model)")
                self?.movies = model.results
                DispatchQueue.main.async {
                    self?.mainView.setPopularMovies(popularMovies: self?.movies)
                    self?.mainView.popularCollectionView.reloadData()
                }

            case .failure(let error):
                print("[NETWORK] error is: \(error)")
                DispatchQueue.main.async {
                    print("\(Constants.errorDescription) \(error.localizedDescription)")
                }
            }
        }

        self.networkService.loadUpcomingMovies { [weak self] (result: Result<MoviesPage, Error>) in
            switch result {
            case .success(let model):
                print("[NETWORK] model is: \(model)")
                self?.movies = model.results
                DispatchQueue.main.async {
                    self?.mainView.setUpcomingMovies(upcomingMovies: self?.movies)
                    self?.mainView.upcomingCollectionView.reloadData()
                }
                
            case .failure(let error):
                print("[NETWORK] error is: \(error)")
                DispatchQueue.main.async {
                    print("\(Constants.errorDescription) \(error.localizedDescription)")
                }
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
