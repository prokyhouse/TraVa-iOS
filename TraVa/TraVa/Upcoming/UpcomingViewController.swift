//
//  UpcomingViewController.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import UIKit

import Foundation
import UIKit
import SnapKit

final class UpcomingViewController: UIViewController {

	private let networkService = NetworkService()
	private let activityIndicator = UIActivityIndicatorView(style: .medium)

	private lazy var collectionView: UICollectionView = {
		let flowLayout = UpcomingFlowLayout()
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		collectionView.alwaysBounceVertical = true
		collectionView.register(UpcomingMovieCell.self, forCellWithReuseIdentifier: UpcomingMovieCell.identifier)
		collectionView.delegate = self
		collectionView.dataSource = self
		return collectionView
	}()

	private var movies: [Movie]?

	func loadUpcomingData() {
		self.activityIndicator.startAnimating()

		self.networkService.loadUpcomingMovies { (result: Result<UpcomingMoviesPage, Error>) in
			switch result {
			case .success(let model):
				print("[NETWORK // UPCOMING] model is: \(model)")
				self.movies = model.results
				DispatchQueue.main.async {
					self.activityIndicator.stopAnimating()
					self.collectionView.reloadData()
				}
			case .failure(let error):
				print("[NETWORK // UPCOMING] error is: \(error)")
				DispatchQueue.main.async {
					self.activityIndicator.stopAnimating()
					print("Загрузка закончена с ошибкой \(error.localizedDescription)")
				}
			}
		}
	}

	override func loadView() {
		self.loadUpcomingData()
		self.view = self.collectionView
		self.view.addSubview(activityIndicator)
		activityIndicator.snp.makeConstraints { maker in
			maker.centerX.equalToSuperview()
			maker.centerY.equalToSuperview()
		}
	}

	override func viewDidLoad() {
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.view.backgroundColor = UIColor.systemBackground
		super.viewDidLoad()
		self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "AccentColor") ?? .systemPurple]
		self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "AccentColor") ?? .systemPurple]
		self.navigationController?.navigationBar.prefersLargeTitles = true
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.tabBar.isHidden = false
	}
}

extension UpcomingViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let movie = self.movies?[indexPath.item] else { return }
		let movieVC = MovieViewController(movie: movie)
		self.navigationController?.pushViewController(movieVC, animated: true)
	}

	func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		return true
	}
}

extension UpcomingViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		self.movies?.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingMovieCell.identifier, for: indexPath) as! UpcomingMovieCell
		cell.movie = self.movies?[indexPath.item]
		return cell
	}
}
