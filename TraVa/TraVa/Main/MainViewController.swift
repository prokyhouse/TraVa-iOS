//
//  ViewController.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 22.12.2021.
//

import UIKit

class MainViewController: UIViewController, MainViewDelegate {
	func pushVC(vc: UIViewController) {
		self.navigationController?.pushViewController(vc, animated: true)
	}


	private var mainView: MainView = MainView()
	private let networkService = NetworkService()
	private var movies : [Movie]?

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "AccentColor") ?? .systemPurple]
	}

	override func loadView() {
		self.loadData()
		self.mainView.delegate = self
		self.view = self.mainView
		self.view.backgroundColor = UIColor.systemBackground
	}

	func loadData() {

		self.networkService.loadData { (result: Result<MoviesPage, Error>) in
			switch result {
			case .success(let model):

				print("[NETWORK] model is: \(model)")
				self.movies = model.results
				DispatchQueue.main.async {
					self.mainView.setMovies(movies: self.movies)
					self.mainView.popularCollectionView.reloadData()
				}
			case .failure(let error):
				print("[NETWORK] error is: \(error)")
				DispatchQueue.main.async {
					print("Загрузка закончена с ошибкой \(error.localizedDescription)")
				}
			}
		}
	}

	
}

