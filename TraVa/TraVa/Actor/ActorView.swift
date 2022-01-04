//
//  ActorView.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 28.12.2021.
//

import Foundation
import Foundation
import UIKit
import SnapKit

final class ActorView: UIView {
	
	private enum Metrics {
		static let spaceBetweenComponents: CGFloat = 20
		static let viewHeight: CGFloat = 960
		static let titleLabelHeight: CGFloat = 30
		static let maxPhotoHeight: CGFloat = 650
	}
	
	private let photoView = UIImageView()
	private let titleLabel = UILabel()
	private let descriptionLabel = UILabel()
	private let contentView = UIView()
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.configure()
	}
	
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.contentView.setGradientBackground(colorTop: .black ,
											   colorBottom: UIColor.clear,
											   startY: 0.4,
											   endY: 0)
	}
	
	private func configure() {
		self.setConfig()
		self.addSubviews()
		self.setConstraints()
	}
	
	private func setConfig() {
		self.backgroundColor = .systemBackground
		
		self.titleLabel.textColor = .white
		
		self.photoView.contentMode = .scaleAspectFill
		
		self.titleLabel.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.bold)
		self.titleLabel.textAlignment = .center
		self.titleLabel.adjustsFontSizeToFitWidth = true
		
		self.descriptionLabel.textColor = .white
		self.descriptionLabel.numberOfLines = 4
		self.descriptionLabel.textAlignment = .center
		self.descriptionLabel.adjustsFontSizeToFitWidth = true
	}
	
	func setContent(actor: Cast) {
		print(actor)
		if actor.profilePath == nil {
			self.photoView.image = UIImage(named: "ActorTemplate")
		} else {
			self.photoView.imageFromUrl(urlString: "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/" + actor.profilePath!)
		}
		
		self.titleLabel.text = actor.name
		self.descriptionLabel.text = actor.character
	}
	
	private func addSubviews() {
		self.addSubview(self.photoView)
		self.addSubview(self.contentView)
		self.contentView.addSubview(self.titleLabel)
		self.contentView.addSubview(self.descriptionLabel)
	}
	
	private func setConstraints() {
		self.photoView.snp.makeConstraints { make in
			make.centerX.equalTo(self.snp.centerX)
			make.left.right.top.equalToSuperview()
			make.bottom.equalToSuperview().offset(-260)
			make.height.lessThanOrEqualTo(Metrics.maxPhotoHeight)
		}
		
		self.contentView.snp.makeConstraints { make in
			make.left.right.equalToSuperview()
			make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
			make.top.equalTo(self.photoView.snp.bottom).offset(-170)
		}
		
		self.titleLabel.snp.makeConstraints { make in
			make.left.right.equalToSuperview().inset(Metrics.spaceBetweenComponents)
			make.top.equalTo(self.contentView.snp.top).offset(84)
			make.height.equalTo(Metrics.titleLabelHeight)
			make.centerX.equalTo(self.contentView.snp.centerX)
		}
		
		self.descriptionLabel.snp.makeConstraints { make in
			make.centerX.equalTo(self.contentView.snp.centerX)
			make.left.right.equalTo(self.contentView).inset(Metrics.spaceBetweenComponents)
			make.top.equalTo(self.titleLabel.snp.bottom).offset(Metrics.spaceBetweenComponents)
		}
	}
}
