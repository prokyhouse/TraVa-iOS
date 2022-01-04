//
//  MainView.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import UIKit
import SnapKit

protocol MainViewDelegate {
	func pushVC(vc: UIViewController)
}

class MainView: UIView {

	internal var popularMovies: [Movie]?
	internal var upcomingMovies: [Movie]?
	internal var delegate: MainViewDelegate?

	private let scrollView = UIScrollView()
	let contentView = UIView()
	let popularLabel = UILabel()
	let upcomingLabel = UILabel()
	let recommendationLabel = UILabel()
	let randomMovieView = MovieCell()

	var popularCollectionView: UICollectionView = {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
		layout.itemSize = CGSize(width: 120, height: 190)
		layout.scrollDirection = .horizontal

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.isScrollEnabled = true
		collectionView.showsHorizontalScrollIndicator = false
		// collectionView.alwaysBounceHorizontal = true
		collectionView.register(MovieCellView.self, forCellWithReuseIdentifier: MovieCellView.identifier)
		return collectionView
	}()

	var upcomingCollectionView: UICollectionView = {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
		layout.itemSize = CGSize(width: 120, height: 190)
		layout.scrollDirection = .horizontal

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.isScrollEnabled = true
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.register(MovieCellView.self, forCellWithReuseIdentifier: MovieCellView.identifier)
		return collectionView
	}()

	internal func setPopularMovies(popularMovies: [Movie]?) {
		self.popularMovies = popularMovies
		self.randomMovieView.movie = popularMovies?.randomElement()
		self.popularCollectionView.reloadData()
	}

	internal func setUpcomingMovies(upcomingMovies: [Movie]?) {
		self.upcomingMovies = upcomingMovies
		self.upcomingCollectionView.reloadData()
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.configure()
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func configure() {
		self.setConfig()
		self.addSubviews()
		self.addDelegate()
		self.setConstraint()
	}

	private func addDelegate() {
		self.popularCollectionView.dataSource = self
		self.popularCollectionView.delegate = self

		self.upcomingCollectionView.dataSource = self
		self.upcomingCollectionView.delegate = self
	}

	private func addSubviews() {
		self.addSubview(self.scrollView)
		self.scrollView.addSubview(self.contentView)
		self.contentView.addSubview(self.popularLabel)
		self.contentView.addSubview(self.popularCollectionView)
		self.contentView.addSubview(self.recommendationLabel)
		self.contentView.addSubview(self.randomMovieView)
		self.contentView.addSubview(self.upcomingLabel)
		self.contentView.addSubview(self.upcomingCollectionView)
	}

	private func setConfig() {
		self.popularLabel.text = "Популярное"
		self.popularLabel.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.bold)

		self.upcomingLabel.text = "Скоро в кино"
		self.upcomingLabel.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.bold)

		self.recommendationLabel.text = "Может быть интересно"
		self.recommendationLabel.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.bold)

		self.randomMovieView.layer.cornerRadius = 12
		self.randomMovieView.clipsToBounds = true
		self.randomMovieView.backgroundColor = .systemBackground
	}

	private func setConstraint() {

		self.scrollView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}

		self.contentView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
			make.width.equalToSuperview()
			make.height.equalToSuperview()
		}

		self.popularLabel.snp.makeConstraints { make in
			make.left.right.equalTo(self.contentView).inset(9)
			make.top.equalTo(self.contentView.snp.top).offset(11)
			make.height.equalTo(33)
		}

		self.popularCollectionView.snp.makeConstraints { make in
			make.left.equalToSuperview()
			make.right.equalToSuperview()
			make.top.equalTo(self.popularLabel.snp.bottom).offset(11)
			make.height.equalTo(190)
		}

		self.recommendationLabel.snp.makeConstraints { make in
			make.left.right.equalTo(self.contentView).inset(9)
			make.top.equalTo(self.popularCollectionView.snp.bottom).offset(11)
			make.height.equalTo(33)
		}

		self.randomMovieView.snp.makeConstraints { make in
			make.left.right.equalTo(self.contentView).inset(9)
			make.top.equalTo(self.recommendationLabel.snp.bottom).offset(11)
			make.height.equalTo(90)
		}

		self.upcomingLabel.snp.makeConstraints { make in
			make.left.right.equalTo(self.contentView).inset(9)
			make.top.equalTo(self.randomMovieView.snp.bottom).offset(11)
			make.height.equalTo(33)
		}

		self.upcomingCollectionView.snp.makeConstraints { make in
			make.left.equalToSuperview()
			make.right.equalToSuperview()
			make.top.equalTo(self.upcomingLabel.snp.bottom).offset(11)
			make.height.equalTo(190)
		}
	}
}

extension MainView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == self.popularCollectionView {
			guard let movie = self.popularMovies?[indexPath.item] else { return }
			let movieVC = MovieViewController(movie: movie)
			delegate?.pushVC(vc: movieVC)
		} else {
			guard let movie = self.upcomingMovies?[indexPath.item] else { return }
			let movieVC = MovieViewController(movie: movie)
			delegate?.pushVC(vc: movieVC)
		}
	}

	func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		return true
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 120, height: 190)
	}
}

extension MainView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == self.popularCollectionView {
			return self.popularMovies?.count ?? 0
		} else {
			return self.upcomingMovies?.count ?? 0
		}
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCellView.identifier, for: indexPath) as! MovieCellView
		if collectionView == self.popularCollectionView {
			cell.movie = self.popularMovies?[indexPath.item]
		} else {
			cell.movie = self.upcomingMovies?[indexPath.item]
		}
		return cell
	}
}
