//
//  ViewController.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 22.12.2021.
//

import UIKit

class MainViewController: UIViewController {

	private var mainView: MainView = MainView()
	private let networkService = NetworkService()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.systemBackground
		//self.loadData()
		//self.view = self.mainView
	}

	override func loadView() {
		self.view = self.mainView
	}

	private var movies : [Movie]? = Movie.sampleData

	func loadData() {

		self.networkService.loadData { (result: Result<MoviesPage, Error>) in
			switch result {
			case .success(let model):

				print("[NETWORK] model is: \(model)")
				self.movies = model.results
				DispatchQueue.main.async {
					self.mainView.movies = Movie.sampleData
					//self.mainView.popularCollectionView.setContent(model: self.movies ?? [])
					self.mainView.popularCollectionView.moviesCollectionView?.reloadData()
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
