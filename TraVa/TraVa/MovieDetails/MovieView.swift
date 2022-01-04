//
//  MovieView.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 25.12.2021.
//

import Foundation
import UIKit
import SnapKit

protocol MovieViewDelegate {
	func pushActorVC(vc: UIViewController)
}

final class MovieView: UIView {

	var screenWidth = UIScreen.main.bounds.size.width
	var screenHeight = UIScreen.main.bounds.size.height
	private let networkService = NetworkService()
	private var actors: [Cast]?
	internal var delegate: MovieViewDelegate?

	private enum Metrics {

		static let spaceBetweenComponents: CGFloat = 20
		static let viewHeight: CGFloat = 960
		static let instButtonHeight: CGFloat = 42
		static let instButtonWidth: CGFloat = 240
		static let titleLabelHeight: CGFloat = 30
		static let screenWidth = UIScreen.main.bounds.size.width
		static let maxPhotoHeight: CGFloat = (screenWidth / 16 ) * 9
	}

	private let photoView = UIImageView()
	public var backdrop: UIImage? = UIImage()
	let instagramButton = UIButton()
	private let titleLabel = UILabel()
	private let descriptionLabel = UILabel()
	private let castLabel = UILabel()
	private let scrollView = UIScrollView()
	private let contentView = UIView()
	private var linkForShare: String = "instagram.com"

	lazy var actorsCollectionView: UICollectionView = {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
		layout.itemSize = CGSize(width: 120, height: 190)
		layout.scrollDirection = .horizontal

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.isScrollEnabled = true
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.register(ActorCellView.self, forCellWithReuseIdentifier: ActorCellView.identifier)
		return collectionView
	}()

	var movie: Movie? {
		didSet {
			guard let movie = movie else { return }
			let imagePath: String = movie.backdropPath ?? movie.posterPath
			self.photoView.imageFromUrl(urlString: "https://www.themoviedb.org/t/p/w1066_and_h600_bestv2/" + imagePath)
			self.backdrop = photoView.image
			// self.imageView.image = UIImage(named: movie.title)
			self.photoView.clipsToBounds = true
			self.titleLabel.text = movie.title
			self.descriptionLabel.text = movie.overview
		}
	}

	public func setMovie(movie: Movie?) {
		self.movie = movie
	}

	public func setCast(actors: [Cast]?) {
		self.actors = actors
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)

		self.configure()
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		self.photoView.setGradientBackground(colorTop: .white ,
											 colorBottom: UIColor.clear,
											 startY: 1,
											 endY: 0.1)
	}

	private func configure() {
		self.setConfig()
		self.addDelegate()
		self.addSubviews()
		self.setConstraints()
	}

	private func addDelegate() {
		self.actorsCollectionView.dataSource = self
		self.actorsCollectionView.delegate = self
	}

	private func setConfig() {

		self.scrollView.backgroundColor = UIColor.systemBackground

		self.instagramButton.backgroundColor = UIColor(named: "AccentColor")
		let imageIcon = UIImage(systemName: "livephoto.play")?.withTintColor(.white, renderingMode: .alwaysOriginal)
		self.instagramButton.setImage(imageIcon, for: .normal)

		self.instagramButton.setTitle("Трейлер", for: .normal)
		self.instagramButton.setTitleColor(.white, for: .normal)
		self.instagramButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
		self.instagramButton.setTitleColor(.black, for: .highlighted)
		self.instagramButton.titleLabel?.adjustsFontSizeToFitWidth = true
		self.instagramButton.layer.cornerRadius = 10

		// MARK: TEST
		self.photoView.contentMode = .scaleAspectFill

		self.titleLabel.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.bold)
		self.titleLabel.textColor = UIColor(named: "AccentColor")
		self.titleLabel.textAlignment = .center
		self.titleLabel.adjustsFontSizeToFitWidth = true

		self.descriptionLabel.numberOfLines = 100

		self.castLabel.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
		self.castLabel.text = "В ролях"
	}

	private func addSubviews() {
		self.addSubview(self.scrollView)
		self.scrollView.addSubview(self.contentView)
		self.contentView.addSubview(self.photoView)
		self.contentView.addSubview(self.titleLabel)
		self.contentView.addSubview(self.descriptionLabel)
		self.contentView.addSubview(self.instagramButton)
		self.contentView.addSubview(self.castLabel)
		self.contentView.addSubview(self.actorsCollectionView)
	}

	private func setConstraints() {

		self.scrollView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()

		}

		self.contentView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
			make.width.equalToSuperview()
			make.height.equalToSuperview()
		}

		self.photoView.snp.makeConstraints { make in
			make.centerX.equalTo(self.snp.centerX)
			make.left.right.equalTo(self.contentView)
			make.top.equalTo(self.contentView.snp.top)
			make.height.lessThanOrEqualTo(Metrics.maxPhotoHeight)
		}

		self.titleLabel.snp.makeConstraints { make in
			make.left.right.equalToSuperview().inset(Metrics.spaceBetweenComponents)
			make.bottom.equalTo(self.photoView.snp.bottom)
			make.height.equalTo(Metrics.titleLabelHeight)
		}

		self.instagramButton.snp.makeConstraints { make in
			make.top.equalTo(self.titleLabel.snp.bottom).offset(Metrics.spaceBetweenComponents)
			make.centerX.equalTo(self.contentView.snp.centerX)
			make.width.equalTo(Metrics.instButtonWidth)
			make.height.equalTo(Metrics.instButtonHeight)
		}

		self.descriptionLabel.snp.makeConstraints { make in
			make.left.right.equalTo(self.contentView).inset(Metrics.spaceBetweenComponents)
			make.top.equalTo(self.instagramButton.snp.bottom).offset(Metrics.spaceBetweenComponents)
		}

		self.castLabel.snp.makeConstraints { make in
			make.left.right.equalTo(self.contentView).inset(Metrics.spaceBetweenComponents)
			make.top.equalTo(self.descriptionLabel.snp.bottom).offset(Metrics.spaceBetweenComponents)
			make.height.equalTo(33)
		}
		self.actorsCollectionView.snp.makeConstraints { make in
			make.left.equalTo(self.contentView)
			make.right.equalTo(self.contentView)
			make.top.equalTo(self.castLabel.snp.bottom).offset(11)
			make.height.equalTo(190)
		}
	}
}

extension MovieView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let actor = self.actors?[indexPath.item] else { return }
		let actorVC = ActorViewController(actor: actor)
		delegate?.pushActorVC(vc: actorVC)
		print("pushed")
		// self.navigationController?.pushViewController(actorVC, animated: true)
	}

	func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		return true
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 120, height: 190)
	}
}

extension MovieView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		print(self.actors?.count as Any)
		return self.actors?.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorCellView.identifier, for: indexPath) as! ActorCellView
		cell.actor = self.actors?[indexPath.item]
		return cell
	}
}
