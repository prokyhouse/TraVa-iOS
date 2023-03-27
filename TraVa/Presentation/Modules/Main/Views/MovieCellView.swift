//
//  MovieCellView.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import Domain
import UIKit
import SnapKit

final class MovieCellView: UICollectionViewCell {

	private enum Metrics {
		static let spaceBetweenComponents: CGFloat = 9
	}

	static let identifier = "MovieCellView"

	private let imageView = UIImageView()
	private let rateLabel = UILabel()
	private let rateBadge = UIView()

	var movie: Movie? {
		didSet {
			guard let movie = movie else { return }
            self.imageView.download(from: "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/" + movie.posterPath)
			self.imageView.clipsToBounds = true
			self.rateLabel.text = String(movie.voteAverage)
		}
	}

	override var isHighlighted: Bool {
		didSet {
			UIView.animate(withDuration: 0.25) {
				self.alpha = self.isHighlighted ? 0.5 : 1.0
			}
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.configure()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func configure() {
		self.setConfig()
		self.addSubviews()
		self.setConstraints()
	}

	private func setConfig() {
		self.imageView.contentMode = .scaleAspectFill
		self.imageView.clipsToBounds = true

		self.rateLabel.textColor = UIColor.white
		self.rateLabel.numberOfLines = 1
		self.rateLabel.textAlignment = .center
		self.rateLabel.font = roundedFont(ofSize: 13, weight: .semibold)
		self.rateLabel.adjustsFontSizeToFitWidth = true

		self.imageView.layer.cornerRadius = 12

		self.layer.cornerRadius = 12

		self.rateBadge.backgroundColor = UIColor(named: "AccentColor")
		self.rateBadge.layer.cornerRadius = 10
	}

	private func addSubviews() {
		self.addSubview(imageView)
		self.imageView.addSubview(rateBadge)
		self.rateBadge.addSubview(rateLabel)
	}

	private func setConstraints() {

		self.imageView.snp.makeConstraints { make in
			make.left.right.top.equalToSuperview()
			make.width.equalToSuperview()
			make.height.equalTo(self.imageView.snp.width).multipliedBy(1.5)
		}

		self.rateBadge.snp.makeConstraints { make in
			make.right.top.equalToSuperview().inset(Metrics.spaceBetweenComponents)
			make.width.equalTo(self.snp.width).dividedBy(4)
			make.height.equalTo(self.rateBadge.snp.width).multipliedBy(0.75)
		}

		self.rateLabel.snp.makeConstraints { make in
			make.right.left.equalToSuperview()
			make.top.bottom.equalToSuperview()
		}
	}
}
