//
//  MovieViewController.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 25.12.2021.
//

import Domain
import Networking
import UIKit
import DesignBook

class MovieViewController: UIViewController, MovieViewDelegate {
    func pushTrailerVC(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func pushActorVC(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private var movie: Movie?
    private var actors: [Cast]?
    private var movieView: MovieView = MovieView()
    private let networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        navigationController?.isNavigationBarHidden = true
    }

    override func loadView() {
        self.loadData()
        self.movieView.delegate = self
        self.navigationController?.navigationBar.prefersLargeTitles = false
        movieView.navBar.delegate = self
        self.view = self.movieView
    }

    init(movie: Movie) {
        self.movie = movie
        self.movieView.setMovie(movie: movie)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadData() {
        guard let id = movie?.id else { return }

        networkService.fetchMovie(movie: id) { [weak self] (result: Result<Movie, Error>) in
            switch result {
            case .success(let model):
                self?.actors = model.credits?.cast
                DispatchQueue.main.async {
                    self?.movieView.setCast(actors: model.credits?.cast)
                    self?.movieView.actorsCollectionView.reloadData()
                }

            case .failure(_):
                break
            }
        }
    }
}

extension MovieViewController: BlurNavigationBarDelegate {
    func onBackTap() {
        navigationController?.popViewController(animated: true)
    }
}
