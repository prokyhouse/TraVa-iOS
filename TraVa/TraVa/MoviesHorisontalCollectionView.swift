//
//  MoviesHorisontalCollectionView.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import UIKit
import SnapKit

final internal class MoviesHorisontalCollectionView: UIView {

	internal var moviesCollectionView: UICollectionView?
	private var contentModel: [Movie]? = Movie.sampleData

	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.configure()
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	internal func setContent(model: [Movie]) {
		self.contentModel = model
		print(model.count)
		self.moviesCollectionView?.reloadData()
	}

	private func configure() {
		self.setConfig()
		self.addSubviews()
		self.setConstraint()
	}

	private func addSubviews() {
		guard let collectionView = self.moviesCollectionView else { return }
		self.addSubview(collectionView)
	}

	private func setConfig() {

		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
		layout.itemSize = CGSize(width: 120, height: 190)
		layout.scrollDirection = .horizontal
		self.moviesCollectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
		self.moviesCollectionView?.register(MovieCellView.self, forCellWithReuseIdentifier: "\(MovieCellView.self)")
		self.moviesCollectionView?.backgroundColor = .white
		self.moviesCollectionView?.showsHorizontalScrollIndicator = false
//		self.moviesCollectionView?.delegate = self
//		self.moviesCollectionView?.dataSource = self

		self.moviesCollectionView?.backgroundColor = UIColor.red
	}

	private func setConstraint() {
		self.moviesCollectionView?.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
}

extension MoviesHorisontalCollectionView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.contentModel?.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let myCell = collectionView.dequeueReusableCell(withReuseIdentifier:
															"\(MovieCellView.self)", for: indexPath) as? MovieCellView
		if let movie = self.contentModel?[indexPath.row] {
			myCell?.set(movie: movie)
			print(movie.id)
		}
		return myCell ?? UICollectionViewCell()
	}
}
