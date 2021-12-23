//
//  MoviesHorisontalCollectionView.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import UIKit
import SnapKit

final internal class MoviesHorisontalCollectionView: UIView {

	private var moviesCollectionView: UICollectionView?
	private var contentModel: [Movie]?

	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.configure()
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	internal func setContent(model: [Movie]) {
		self.contentModel = model
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
		layout.itemSize = CGSize(width: 162, height: 190)
		layout.scrollDirection = .horizontal
		self.moviesCollectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
		self.moviesCollectionView?.register(MovieCellView.self, forCellWithReuseIdentifier: "\(MovieCellView.self)")
		self.moviesCollectionView?.backgroundColor = .white
		self.moviesCollectionView?.showsHorizontalScrollIndicator = false
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
//		if let event = self.contentModel?[indexPath.row] {
//			myCell?.set(event: event)
//		}
		return myCell ?? UICollectionViewCell()
	}
}
