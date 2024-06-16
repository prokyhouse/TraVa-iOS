//
//  PopularViewController.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import Domain
import Networking
import UIKit
import SnapKit

public final class PopularViewController: UIViewController {
    public var presenter: PopularPresenter?

    // MARK: - Private properties

    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var movies: [Movie]?

    private lazy var collectionView: UICollectionView = {
        let flowLayout = FlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.alwaysBounceVertical = true
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self

        return collectionView
    }()

    // MARK: - Lifecycle

    public override func loadView() {
        self.loadData()
        self.view = self.collectionView
        self.view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
    }

    public override func viewDidLoad() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = UIColor.systemBackground

        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "AccentColor") ?? .systemPurple]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "AccentColor") ?? .systemPurple]
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    public func setPopularMovies(_ movies: [Movie]) {
        self.movies = movies
        activityIndicator.stopAnimating()
        collectionView.reloadData()
    }
}

// MARK: - Private methods

private extension PopularViewController {
    func loadData() {
        activityIndicator.startAnimating()
        presenter?.fetchPopularMovies()
    }
}

extension PopularViewController: UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let movie = self.movies?[indexPath.item] else { return }
        guard let movieId = movie.id else { return }

        presenter?.showMovieDetails(movieId)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        shouldHighlightItemAt indexPath: IndexPath
    ) -> Bool {
        return true
    }
}

extension PopularViewController: UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.movies?.count ?? 0
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCell.identifier,
            for: indexPath
        ) as! MovieCell
        cell.movie = self.movies?[indexPath.item]

        return cell
    }
}
