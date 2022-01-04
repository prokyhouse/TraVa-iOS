//
//  UpcomingMovieCell.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 24.12.2021.
//

import Foundation
import UIKit
import SnapKit

final class UpcomingMovieCell: UICollectionViewCell {
	
	private enum Metrics {
		static let spaceBetweenComponents: CGFloat = 9
	}
	
	static let identifier = "UpcomingMovieCell"
	
	private let imageView = UIImageView()
	private let nameLabel = UILabel()
	private let rateLabel = UILabel()
	private let rateBadge = UIView()
	
	var movie: Movie? {
		didSet {
			guard let movie = movie else { return }
			self.imageView.imageFromUrl(urlString: "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/" + movie.posterPath)
			self.imageView.clipsToBounds = true
			self.nameLabel.text = movie.title
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
		
		self.nameLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
		self.nameLabel.numberOfLines = 2
		
		self.imageView.layer.cornerRadius = 12
		
		self.layer.cornerRadius = 10
		
		self.rateBadge.backgroundColor = UIColor(named: "AccentColor")
		self.rateBadge.layer.cornerRadius = 12
	}
	
	private func addSubviews() {
		self.addSubview(imageView)
		self.addSubview(nameLabel)
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
			make.width.equalTo(self.snp.width).dividedBy(5)
			make.height.equalTo(self.rateBadge.snp.width).multipliedBy(0.75)
		}
		
		self.nameLabel.snp.makeConstraints { make in
			make.top.equalTo(self.imageView.snp.bottom).offset(Metrics.spaceBetweenComponents)
			make.left.right.equalToSuperview()
		}
		self.rateLabel.snp.makeConstraints { make in
			make.right.left.equalToSuperview()
			make.top.bottom.equalToSuperview()
		}
	}
}

func roundedFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
	if let descriptor = UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor.withDesign(.rounded) {
		return UIFont(descriptor: descriptor, size: fontSize)
	} else {
		return UIFont.systemFont(ofSize: fontSize, weight: weight)
	}
}
