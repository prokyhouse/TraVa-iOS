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

public final class MovieViewController: UIViewController {
    public var presenter: MovieViewPresenter?

    private var movieView: MovieView = MovieView()
    private let networkService = NetworkService()

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        navigationController?.isNavigationBarHidden = true
    }

    public override func loadView() {
        self.loadData()
        self.movieView.delegate = self
        self.navigationController?.navigationBar.prefersLargeTitles = false
        movieView.navBar.delegate = self
        self.view = self.movieView
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadData() {
        presenter?.fetchMovie()
    }

    // MARK: - Public methods

    public func setMovie(_ movie: Movie) {
        movieView.setMovie(movie: movie)
        movieView.setCast(actors: movie.credits?.cast)
        movieView.actorsCollectionView.reloadData()
    }
}

// MARK: - MovieViewDelegate

extension MovieViewController: MovieViewDelegate {
    public func showActorDetails(_ actor: Domain.Cast) {
        presenter?.showActor(actor)
    }
}

// MARK: - BlurNavigationBarDelegate

extension MovieViewController: BlurNavigationBarDelegate {
    public func onBackTap() {
        navigationController?.popViewController(animated: true)
    }
}
