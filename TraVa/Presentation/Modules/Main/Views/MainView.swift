//
//  MainView.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import UIKit
import Domain
import SnapKit

protocol MainViewDelegate {
    func onPopularSectionTap()
    func onUpcomingSectionTap()
    func onMovieTap(with id: Int)
}

public final class MainView: UIView {
    internal var delegate: MainViewDelegate?

    // MARK: - Internal properties

    private var popularMovies: [Movie]?
    private var upcomingMovies: [Movie]?

    // MARK: - Views

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let randomMovieView = MovieCell()

    private lazy var popularLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.popular
        label.font = UIFont.systemFont(
            ofSize: Constants.titleSize,
            weight: Constants.titleWeight
        )
        return label
    }()

    let upcomingLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.soon
        label.font = UIFont.systemFont(
            ofSize: Constants.titleSize,
            weight: Constants.titleWeight
        )
        return label
    }()

    let recommendationLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.recommendation
        label.font = UIFont.systemFont(
            ofSize: Constants.titleSize,
            weight: Constants.titleWeight
        )
        return label
    }()

    private lazy var popularChevroneButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onPopularChevroneTap), for: .touchUpInside)
        let chevrone = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = UIColor(named: "AccentColor")
        button.setImage(chevrone, for: .normal)
        return button
    }()

    private lazy var upcomingChevroneButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onUpcomingChevroneTap), for: .touchUpInside)
        let chevrone = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = UIColor(named: "AccentColor")
        button.setImage(chevrone, for: .normal)
        return button
    }()

    private(set) lazy var popularCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(
            top: .zero,
            left: Constants.collectionsHorizontalInsets,
            bottom: .zero,
            right: Constants.collectionsHorizontalInsets
        )
        layout.itemSize = CGSize(
            width: Constants.cellWidth,
            height: Constants.collectionsHeight
        )
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            MovieCellView.self,
            forCellWithReuseIdentifier: MovieCellView.identifier
        )
        return collectionView
    }()

    private(set) lazy var upcomingCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(
            top: .zero,
            left: Constants.collectionsHorizontalInsets,
            bottom: .zero,
            right: Constants.collectionsHorizontalInsets
        )
        layout.itemSize = CGSize(
            width: Constants.cellWidth,
            height: Constants.collectionsHeight
        )
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            MovieCellView.self,
            forCellWithReuseIdentifier: MovieCellView.identifier
        )
        return collectionView
    }()

    // MARK: - Lifecycle

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        configure()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func setPopularMovies(popularMovies: [Movie]?) {
        self.popularMovies = popularMovies
        randomMovieView.movie = popularMovies?.randomElement()
        popularCollectionView.reloadData()
    }

    func setUpcomingMovies(upcomingMovies: [Movie]?) {
        self.upcomingMovies = upcomingMovies
        upcomingCollectionView.reloadData()
    }
}

// MARK: - Private methods

private extension MainView {
    func addDelegate() {
        popularCollectionView.dataSource = self
        popularCollectionView.delegate = self

        upcomingCollectionView.dataSource = self
        upcomingCollectionView.delegate = self
    }

    func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        [
            popularLabel,
            popularChevroneButton,
            popularCollectionView,
            recommendationLabel,
            randomMovieView,
            upcomingLabel,
            upcomingChevroneButton,
            upcomingCollectionView
        ].forEach {
            contentView.addSubview($0)
        }
    }

    func configure() {
        addDelegate()

        randomMovieView.layer.cornerRadius = 12
        randomMovieView.clipsToBounds = true
        randomMovieView.backgroundColor = .systemBackground

        popularCollectionView.backgroundColor = .systemBackground
        upcomingCollectionView.backgroundColor = .systemBackground
    }

    func setupConstraints() {
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
            popularLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.verticalSpacing
            ),
            popularLabel.leftAnchor.constraint(
                equalTo: contentView.leftAnchor,
                constant: Constants.horizontalSpacing
            ),
            popularLabel.rightAnchor.constraint(equalTo: popularChevroneButton.leftAnchor),
            popularLabel.heightAnchor.constraint(equalToConstant: Constants.titleHeight)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            popularChevroneButton.centerYAnchor.constraint(equalTo: popularLabel.centerYAnchor),
            popularChevroneButton.leftAnchor.constraint(equalTo: popularLabel.rightAnchor),
            popularChevroneButton.rightAnchor.constraint(
                equalTo: contentView.rightAnchor,
                constant: -Constants.horizontalSpacing
            ),
            popularChevroneButton.heightAnchor.constraint(equalToConstant: Constants.chevroneSize),
            popularChevroneButton.widthAnchor.constraint(equalToConstant: Constants.chevroneSize)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            popularCollectionView.topAnchor.constraint(
                equalTo: popularLabel.bottomAnchor,
                constant: Constants.verticalSpacing
            ),
            popularCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            popularCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            popularCollectionView.heightAnchor.constraint(equalToConstant: Constants.collectionsHeight)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            recommendationLabel.topAnchor.constraint(
                equalTo: popularCollectionView.bottomAnchor,
                constant: Constants.verticalSpacing
            ),
            recommendationLabel.leftAnchor.constraint(
                equalTo: contentView.leftAnchor,
                constant: Constants.horizontalSpacing
            ),
            recommendationLabel.rightAnchor.constraint(
                equalTo: contentView.rightAnchor,
                constant: -Constants.horizontalSpacing
            ),
            recommendationLabel.heightAnchor.constraint(equalToConstant: Constants.titleHeight)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            randomMovieView.topAnchor.constraint(
                equalTo: recommendationLabel.bottomAnchor,
                constant: Constants.verticalSpacing
            ),
            randomMovieView.leftAnchor.constraint(
                equalTo: contentView.leftAnchor,
                constant: Constants.horizontalSpacing
            ),
            randomMovieView.rightAnchor.constraint(
                equalTo: contentView.rightAnchor,
                constant: -Constants.horizontalSpacing
            ),
            randomMovieView.heightAnchor.constraint(equalToConstant: 90.0)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            upcomingLabel.topAnchor.constraint(
                equalTo: randomMovieView.bottomAnchor,
                constant: Constants.verticalSpacing
            ),
            upcomingLabel.leftAnchor.constraint(
                equalTo: contentView.leftAnchor,
                constant: Constants.horizontalSpacing
            ),
            upcomingLabel.rightAnchor.constraint(equalTo: upcomingChevroneButton.leftAnchor),
            upcomingLabel.heightAnchor.constraint(equalToConstant: Constants.titleHeight)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            upcomingChevroneButton.centerYAnchor.constraint(equalTo: upcomingLabel.centerYAnchor),
            upcomingChevroneButton.leftAnchor.constraint(equalTo: upcomingLabel.rightAnchor),
            upcomingChevroneButton.rightAnchor.constraint(
                equalTo: contentView.rightAnchor,
                constant: -Constants.horizontalSpacing
            ),
            upcomingChevroneButton.heightAnchor.constraint(equalToConstant: Constants.chevroneSize),
            upcomingChevroneButton.widthAnchor.constraint(equalToConstant: Constants.chevroneSize)
        ])
        NSLayoutConstraint.useAndActivateConstraints([
            upcomingCollectionView.topAnchor.constraint(
                equalTo: upcomingLabel.bottomAnchor,
                constant: Constants.verticalSpacing
            ),
            upcomingCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            upcomingCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            upcomingCollectionView.heightAnchor.constraint(equalToConstant: Constants.collectionsHeight),
            upcomingCollectionView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constants.verticalSpacing
            )
        ])
    }

    @objc
    func onPopularChevroneTap() {
        delegate?.onPopularSectionTap()
    }

    @objc
    func onUpcomingChevroneTap() {
        delegate?.onUpcomingSectionTap()
    }
}

// MARK: - UICollectionViewDelegate

extension MainView: UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if collectionView == self.popularCollectionView {
            guard let movie = self.popularMovies?[indexPath.item] else { return }

            delegate?.onMovieTap(with: movie.id)
        } else {
            guard let movie = self.upcomingMovies?[indexPath.item] else { return }

            delegate?.onMovieTap(with: movie.id)
        }
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
            height: Constants.collectionsHeight
        )
    }
}

// MARK: - UICollectionViewDataSource

extension MainView: UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == self.popularCollectionView {
            return self.popularMovies?.count ?? 0
        } else {
            return self.upcomingMovies?.count ?? 0
        }
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCellView.identifier,
            for: indexPath
        ) as! MovieCellView
        if collectionView == self.popularCollectionView {
            cell.movie = self.popularMovies?[indexPath.item]
        } else {
            cell.movie = self.upcomingMovies?[indexPath.item]
        }
        return cell
    }
}

// MARK: - Constants

private extension MainView {
    enum Constants {
        static let soon: String = "Скоро в кино"
        static let popular: String = "Популярное"
        static let recommendation: String = "Может быть интересно"

        static let cellWidth: CGFloat = 120.0
        static let titleSize: CGFloat = 28.0
        static let titleHeight: CGFloat = 33.0
        static let chevroneSize: CGFloat = titleHeight
        static let titleWeight: UIFont.Weight = .bold
        static let verticalSpacing: CGFloat = 11.0
        static let horizontalSpacing: CGFloat = 9.0
        static let collectionsHeight: CGFloat = 190.0
        static let collectionsHorizontalInsets: CGFloat = 10.0
    }
}
