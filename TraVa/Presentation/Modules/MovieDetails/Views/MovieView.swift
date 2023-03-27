//
//  MovieView.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 25.12.2021.
//

import Domain
import DesignBook
import Networking
import UIKit
import SnapKit

public protocol MovieViewDelegate {
    func showActorDetails(_ actor: Cast)
}

public final class MovieView: UIView {
    // MARK: - Public properties

    public var delegate: MovieViewDelegate?
    public var movie: Movie? {
        didSet {
            setupUI(with: movie)
        }
    }

    // MARK: - Private properties

    private var actors: [Cast]?

    // MARK: - Views

    private(set) lazy var navBar: BlurNavigationBar = {
        let navBar = BlurNavigationBar()
        return navBar
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private let contentView = UIView()

    private let photoView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    private lazy var trailerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        let icon = Constants.trailerIcon?.withTintColor(.white, renderingMode: .alwaysTemplate)
        button.setImage(icon, for: .normal)
        button.setTitle(Constants.trailerTitle, for: .normal)
        button.setTitleColor(Appearance.accentColor, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(
            top: .zero,
            left: 10.0,
            bottom: .zero,
            right: .zero
        )
        button.setTitleColor(.black, for: .highlighted)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.cornerRadius = Constants.buttonHeight / 2
        button.addTarget(self, action: #selector(onTrailerTap), for: .touchUpInside)
        return button
    }()

    private lazy var descriptionLabel: UILabel = {
        let description = UILabel()
        description.numberOfLines = 0
        description.textColor = .white
        return description
    }()

    private let castLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
        label.text = Constants.castTitle
        return label
    }()

    private lazy var infoView: UIView = {
        let view = UIView()
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerRadius = 32.0
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        view.backgroundColor = Appearance.accentColor
        return view
    }()

    private lazy var actorsFlowLayout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(
            top: .zero,
            left: 10,
            bottom: .zero,
            right: 10
        )
        layout.itemSize = CGSize(
            width: Constants.cellWidth,
            height: Constants.cellHeight
        )
        return layout
    }()

    private(set) lazy var actorsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: actorsFlowLayout
        )
        collectionView.register(
            ActorCellView.self,
            forCellWithReuseIdentifier: ActorCellView.identifier
        )
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    // MARK: - Lifecycle

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        photoView.setGradientBackground(colorTop: .clear ,
                                        colorBottom: Appearance.accentColor,
                                        startY: 0.6,
                                        endY: 1.0)
        setupScrollInsets()
    }

    // MARK: - Public methods

    public func setMovie(movie: Movie?) {
        self.movie = movie
    }

    public func setCast(actors: [Cast]?) {
        self.actors = actors
    }
}

// MARK: - Private methods

private extension MovieView {
    func configure() {
        self.addDelegate()
        self.addSubviews()
        self.setConstraints()
    }

    func setupUI(with movie: Movie?) {
        guard let movie = movie else { return }

        let imagePath: String = movie.backdropPath ?? movie.posterPath
        setPhoto(from: imagePath)

        navBar.title = movie.title
        descriptionLabel.text = movie.overview
    }

    func addDelegate() {
        self.actorsCollectionView.dataSource = self
        self.actorsCollectionView.delegate = self
    }

    func setupScrollInsets() {
        scrollView.contentInset.bottom = .zero
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset.top = navBar.bounds.height - 32.0
    }

    func addSubviews() {
        addSubview(scrollView)
        addSubview(navBar)
        scrollView.addSubview(contentView)
        contentView.addSubview(photoView)
        contentView.addSubview(infoView)
        contentView.addSubview(castLabel)
        contentView.addSubview(actorsCollectionView)
        contentView.addSubview(trailerButton)
        infoView.addSubview(descriptionLabel)
    }

    func setConstraints() {
        NSLayoutConstraint.useAndActivateConstraints([
            navBar.leftAnchor.constraint(equalTo: leftAnchor),
            navBar.rightAnchor.constraint(equalTo: rightAnchor),
            navBar.topAnchor.constraint(equalTo: topAnchor)
        ])

        NSLayoutConstraint.useAndActivateConstraints([
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])

        NSLayoutConstraint.useAndActivateConstraints([
            contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        NSLayoutConstraint.useAndActivateConstraints([
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            photoView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            photoView.heightAnchor.constraint(equalToConstant: Constants.photoHeight)
        ])

        NSLayoutConstraint.useAndActivateConstraints([
            trailerButton.centerYAnchor.constraint(equalTo: infoView.topAnchor),
            trailerButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            trailerButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            trailerButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.hSpacing * 2),
            trailerButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.hSpacing * 2)
        ])

        NSLayoutConstraint.useAndActivateConstraints([
            infoView.topAnchor.constraint(equalTo: photoView.bottomAnchor),
            infoView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            infoView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            infoView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.hSpacing * 2)
        ])

        NSLayoutConstraint.useAndActivateConstraints([
            descriptionLabel.topAnchor.constraint(equalTo: trailerButton.bottomAnchor, constant: Constants.hSpacing),
            descriptionLabel.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: Constants.hSpacing),
            descriptionLabel.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -Constants.hSpacing)
        ])

        NSLayoutConstraint.useAndActivateConstraints([
            castLabel.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: Constants.hSpacing / 2),
            castLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.hSpacing),
            castLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.hSpacing),
            castLabel.heightAnchor.constraint(equalToConstant: Constants.hSpacing * 2)
        ])

        NSLayoutConstraint.useAndActivateConstraints([
            actorsCollectionView.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: Constants.hSpacing / 2),
            actorsCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            actorsCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            actorsCollectionView.heightAnchor.constraint(equalToConstant: Constants.cellHeight),
            actorsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.hSpacing)
        ])
    }

    func setPhoto(from path: String) {
        photoView.imageFromUrl(urlString: Constants.photoBaseUrl + path)
    }

    @objc
    func onTrailerTap() {
       // TODO: - воспроизведение видео
    }
}

extension MovieView: UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let actor = self.actors?[indexPath.item] else { return }
        delegate?.showActorDetails(actor)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        shouldHighlightItemAt indexPath: IndexPath
    ) -> Bool {
        return true
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: Constants.cellWidth,
            height: Constants.cellHeight
        )
    }
}

extension MovieView: UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return actors?.count ?? 0
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ActorCellView.identifier,
            for: indexPath
        ) as! ActorCellView
        cell.actor = actors?[indexPath.item]
        return cell
    }
}

private extension MovieView {
    enum Constants {
        static let hSpacing: CGFloat = 16.0
        static let cellWidth: CGFloat = 120.0
        static let cellHeight: CGFloat = 190.0
        static let buttonHeight: CGFloat = 42.0
        static let photoHeight: CGFloat = (screenWidth / 4 ) * 3
        static let screenWidth = UIScreen.main.bounds.size.width
        static let castTitle: String = "В ролях"
        static let trailerTitle: String = "Трейлер"
        static let trailerIcon: UIImage? = UIImage(systemName: "livephoto.play")
        static let photoBaseUrl: String = "https://www.themoviedb.org/t/p/w1066_and_h600_bestv2/"
    }

    enum Appearance {
        static let accentColor: UIColor = UIColor(named: "AccentColor") ?? .systemPurple
    }
}
