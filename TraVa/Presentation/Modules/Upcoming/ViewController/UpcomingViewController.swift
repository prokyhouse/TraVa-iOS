//
//  UpcomingViewController.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import UIKit
import Networking
import Domain
import UIKit
import SnapKit

public final class UpcomingViewController: UIViewController {
    public var presenter: UpcomingPresenter?

    // MARK: - Private properties

    private let networkService = NetworkService()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var movies: [Movie]?

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UpcomingFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.alwaysBounceVertical = true
        collectionView.register(UpcomingMovieCell.self, forCellWithReuseIdentifier: UpcomingMovieCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self

        return collectionView
    }()

    // MARK: - Lifecycle

    public override func loadView() {
        self.loadUpcomingData()
        self.view = self.collectionView
        self.view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
    }

    public override func viewDidLoad() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.systemBackground
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "AccentColor") ?? .systemPurple]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "AccentColor") ?? .systemPurple]
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    public func setUpcomingMovies(_ movies: [Movie]) {
        self.movies = movies
        activityIndicator.stopAnimating()
        collectionView.reloadData()
    }

    public func displayNetworkError() {
        activityIndicator.stopAnimating()
        //TODO: Полноэкранная ошибка
    }
}

// MARK: - Private methods

private extension UpcomingViewController {
    func loadUpcomingData() {
        activityIndicator.startAnimating()
        presenter?.fetchUpcomingMovies()
    }
}

extension UpcomingViewController: UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let movie = self.movies?[indexPath.item] else { return }
        presenter?.showMovieDetails(movie.id)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        shouldHighlightItemAt indexPath: IndexPath
    ) -> Bool {
        return true
    }
}

extension UpcomingViewController: UICollectionViewDataSource {
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
            withReuseIdentifier: UpcomingMovieCell.identifier,
            for: indexPath
        ) as! UpcomingMovieCell
        cell.movie = self.movies?[indexPath.item]
        return cell
    }
}
