//
//  MovieViewController.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 25.12.2021.
//

import Foundation
import UIKit

class MovieViewController: UIViewController, MovieViewDelegate {
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
	}

	override func loadView() {
		self.loadData()
		self.movieView.delegate = self
		self.navigationController?.navigationBar.prefersLargeTitles = false
		self.view = self.movieView
	}

	init(movie: Movie) {
		self.movie = movie
		networkService.setMovieUrl(id: movie.id)
		self.movieView.setMovie(movie: movie)
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func loadData() {
		self.networkService.loadActors { (result: Result<Movie, Error>) in
			switch result {
			case .success(let model):

				print("[NETWORK // MOVIE] model is: \(model)")
				self.actors = model.credits?.cast
				DispatchQueue.main.async {
					self.movieView.setCast(actors: model.credits?.cast)
					self.movieView.actorsCollectionView.reloadData()
				}
			case .failure(let error):
				print("[NETWORK // MOVIE] error is: \(error)")
				DispatchQueue.main.async {

					print("Загрузка закончена с ошибкой \(error.localizedDescription)")
				}
			}
		}
	}
}
