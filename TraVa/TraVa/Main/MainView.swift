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

	internal var movies : [Movie]?
	var delegate: MainViewDelegate?

	private let scrollView = UIScrollView()
	let contentView = UIView()
	let popularLabel = UILabel()
	
	var popularCollectionView: UICollectionView = {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
		layout.itemSize = CGSize(width: 120, height: 190)
		layout.scrollDirection = .horizontal

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		//collectionView.isPagingEnabled = true
		collectionView.isScrollEnabled = true
		collectionView.showsHorizontalScrollIndicator = false
		//collectionView.alwaysBounceHorizontal = true
		collectionView.register(MovieCellView.self, forCellWithReuseIdentifier: MovieCellView.identifier)
		return collectionView
	}()

	struct MainScreenContent {
		internal let PopularText: String = "Популярное"
		internal let UpcomingText: String = "Скоро в кино"
	}

	internal func setMovies(movies: [Movie]?) {
		self.movies = movies
		//self.updateConstraint()
		self.popularCollectionView.reloadData()
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
	}

	private func addSubviews() {
		self.addSubview(self.scrollView)
		self.scrollView.addSubview(self.contentView)
		self.contentView.addSubview(self.popularLabel)
		self.contentView.addSubview(self.popularCollectionView)
	}

	private func setConfig() {
		self.popularLabel.text = "Популярное"
		self.popularLabel.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.bold)
	}

	private func updateConstraint() {
		guard let movies = self.movies else {
			return
		}
		self.popularCollectionView.snp.remakeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(self.popularLabel.snp.bottom)
			let width = 130 * movies.count
			make.width.equalTo(width)
			make.height.equalTo(190)
		}
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

	}
}

extension MainView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let movie = self.movies?[indexPath.item] else { return }
		let movieVC = MovieViewController(movie: movie)
		delegate?.pushVC(vc: movieVC)
		//self.navigationController?.pushViewController(movieVC, animated: true)
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
		print (self.movies?.count)
		return self.movies?.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCellView.identifier, for: indexPath) as! MovieCellView
		cell.movie = self.movies?[indexPath.item]
		print(self.movies?[indexPath.item].title)
		return cell
	}
}



