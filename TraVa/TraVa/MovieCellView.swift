//
//  MovieCellView.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import UIKit
import SnapKit

protocol IMovieCellView {
	func set(movie: Movie)
}

final internal class MovieCellView: UICollectionViewCell {

	private let poster = UIImageView()

	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.configure()
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func configure() {
		self.addSubviews()
		self.setConstraint()
		self.setConfig()
	}

	private func addSubviews() {
		self.addSubview(self.poster)
	}

	private func setConfig() {
		self.layer.cornerRadius = 12
	}

	private func setConstraint() {
		self.snp.makeConstraints { make in
			make.height.equalTo(180)
			make.width.equalTo(120)
		}
		self.poster.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
}

extension MovieCellView: IMovieCellView {
	func set(movie: Movie) {
//		self.cellTitle.text = event.title
	}
}
