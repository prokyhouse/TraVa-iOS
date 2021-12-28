//
//  ActorViewCell.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 27.12.2021.
//

import Foundation
import UIKit
import SnapKit

final class ActorCellView: UICollectionViewCell {

	private enum Metrics {
		static let spaceBetweenComponents: CGFloat = 9
	}

	static let identifier = "ActorCell"

	private let imageView = UIImageView()

	var actor: Cast? {
		didSet {
			guard let actor = actor else { return }
			if actor.profilePath == nil {
			self.imageView.image = UIImage(named: "ActorTemplate")
			} else {
			self.imageView.imageFromUrl(urlString: "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/" + actor.profilePath!)
			}
			//self.imageView.image = UIImage(named: movie.title)
			self.imageView.clipsToBounds = true
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

		self.imageView.layer.cornerRadius = 12

		self.layer.cornerRadius = 10
	}

	private func addSubviews() {
		self.addSubview(imageView)
	}

	private func setConstraints() {

		self.imageView.snp.makeConstraints { make in
			make.left.right.top.equalToSuperview()
			make.width.equalToSuperview()
			make.height.equalTo(self.imageView.snp.width).multipliedBy(1.5)
		}
	}
}
