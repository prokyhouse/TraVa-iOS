//
//  MovieViewController.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 25.12.2021.
//

import Foundation
import UIKit

class MovieViewController: UIViewController {

	private var movie : Movie? = Movie.sampleData[0]
	private var movieView: MovieView = MovieView()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.systemBackground
	}

	override func loadView() {
		self.movieView.setMovie(movie: movie)
		self.navigationController?.navigationBar.prefersLargeTitles = false
		self.view = self.movieView
	}

	init(movie: Movie) {
		self.movie = movie
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
