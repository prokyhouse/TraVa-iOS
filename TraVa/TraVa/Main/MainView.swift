//
//  MainView.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import UIKit
import SnapKit

class MainView: UIView {

	struct MainScreenContent {
		internal let PopularText = "Популярное"
		internal let UpcomingText = "Скоро в кино"
	}

	private let contentView = UIView()
	private let scrollView = UIScrollView()
	private let popularLabel = UILabel()
	private let popularCollectionView = MoviesHorisontalCollectionView()

	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.configure()
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	internal func setContent() {

		self.updateConstraint()
	}

	private func configure() {
		self.addSubviews()
		self.setConstraint()
		self.setConfig()
	}

	private func addSubviews() {
		self.addSubview(self.scrollView)
		self.scrollView.addSubview(self.contentView)

		self.contentView.addSubview(self.popularLabel)
		self.contentView.addSubview(self.popularCollectionView)

	}

	private func setConfig() {

	}

	private func updateConstraint() {

	}

	private func setConstraint() {
		self.scrollView.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
			make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
		}

		self.contentView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
			make.width.equalToSuperview()
		}

		self.popularLabel.snp.makeConstraints { (make) in
			make.left.equalToSuperview().offset(11)
			make.top.equalTo(self.contentView.snp.top).offset(20)
			make.right.equalToSuperview().offset(-11)
			make.height.equalTo(33)
		}

		self.popularCollectionView.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(self.popularLabel.snp.bottom).offset(11)
			make.height.equalTo(190)
		}
	}
}
