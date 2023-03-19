//
//  MainView.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 23.12.2021.
//

import UIKit
import SnapKit

protocol MainViewDelegate {
    func pushVC(vc: UIViewController)
}

public final class MainView: UIView {
    // MARK: - Internal properties

    internal var popularMovies: [Movie]?
    internal var upcomingMovies: [Movie]?
    internal var delegate: MainViewDelegate?

    // MARK: - Views

    private let scrollView = UIScrollView()
    let contentView = UIView()
    let popularLabel = UILabel()
    let upcomingLabel = UILabel()
    let recommendationLabel = UILabel()
    let randomMovieView = MovieCell()

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

    internal func setPopularMovies(popularMovies: [Movie]?) {
        self.popularMovies = popularMovies
        randomMovieView.movie = popularMovies?.randomElement()
        popularCollectionView.reloadData()
    }

    internal func setUpcomingMovies(upcomingMovies: [Movie]?) {
        self.upcomingMovies = upcomingMovies
        upcomingCollectionView.reloadData()
    }

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
        [
            contentView,
            popularLabel,
            popularCollectionView,
            recommendationLabel,
            randomMovieView,
            upcomingLabel,
            upcomingCollectionView
        ].forEach {
            scrollView.addSubview($0)
        }
    }

    func configure() {
        addDelegate()

        popularLabel.text = Constants.popular
        popularLabel.font = UIFont.systemFont(
            ofSize: Constants.titleSize,
            weight: Constants.titleWeight
        )

        upcomingLabel.text = Constants.soon
        upcomingLabel.font = UIFont.systemFont(
            ofSize: Constants.titleSize,
            weight: Constants.titleWeight
        )

        recommendationLabel.text = Constants.recommendation
        recommendationLabel.font = UIFont.systemFont(
            ofSize: Constants.titleSize,
            weight: Constants.titleWeight
        )

        randomMovieView.layer.cornerRadius = 12
        randomMovieView.clipsToBounds = true
        randomMovieView.backgroundColor = .systemBackground

        popularCollectionView.backgroundColor = .systemBackground
        upcomingCollectionView.backgroundColor = .systemBackground
    }

    func setupConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        popularLabel.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(Constants.horizontalSpacing)
            make.top.equalTo(contentView.snp.top).offset(Constants.verticalSpacing)
            make.height.equalTo(Constants.titleHeight)
        }
        popularCollectionView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(popularLabel.snp.bottom).offset(Constants.verticalSpacing)
            make.height.equalTo(Constants.collectionsHeight)
        }
        recommendationLabel.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(Constants.horizontalSpacing)
            make.top.equalTo(popularCollectionView.snp.bottom).offset(Constants.verticalSpacing)
            make.height.equalTo(Constants.titleHeight)
        }
        randomMovieView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(Constants.horizontalSpacing)
            make.top.equalTo(recommendationLabel.snp.bottom).offset(Constants.verticalSpacing)
            make.height.equalTo(90)
        }
        upcomingLabel.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(Constants.horizontalSpacing)
            make.top.equalTo(randomMovieView.snp.bottom).offset(Constants.verticalSpacing)
            make.height.equalTo(Constants.titleHeight)
        }
        upcomingCollectionView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(upcomingLabel.snp.bottom).offset(Constants.verticalSpacing)
            make.height.equalTo(Constants.collectionsHeight)
        }
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

            let movieVC = MovieViewController(movie: movie)
            delegate?.pushVC(vc: movieVC)
        } else {
            guard let movie = self.upcomingMovies?[indexPath.item] else { return }

            let movieVC = MovieViewController(movie: movie)
            delegate?.pushVC(vc: movieVC)
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
        static let titleWeight: UIFont.Weight = .bold
        static let verticalSpacing: CGFloat = 11.0
        static let horizontalSpacing: CGFloat = 9.0
        static let collectionsHeight: CGFloat = 190.0
        static let collectionsHorizontalInsets: CGFloat = 10.0
    }
}
