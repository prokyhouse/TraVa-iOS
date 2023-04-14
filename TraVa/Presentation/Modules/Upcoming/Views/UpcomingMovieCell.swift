//
//  UpcomingMovieCell.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 24.12.2021.
//

import DesignBook
import Domain
import UIKit
import SnapKit

final class UpcomingMovieCell: UICollectionViewCell {

    static let identifier = Constants.identifier

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.cornerRadius

        return view
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = AppResources.fonts.ssPro.semibold.ofSize(20)
        label.numberOfLines = 2

        return label
    }()

    private let rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppResources.colors.textOnSecond
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = AppResources.fonts.ssPro.bold.ofSize(13)
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    private lazy var rateBadge: UIView = {
        let view = UIView()
        view.backgroundColor = AppResources.colors.accent
        view.layer.cornerRadius = Constants.cornerRadius

        return view
    }()

    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            self.imageView.download(from: Constants.posterURL + movie.posterPath)
            self.imageView.clipsToBounds = true
            self.nameLabel.text = movie.title
            self.rateLabel.text = String(movie.voteAverage)
        }
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: Constants.animationDuration) {
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
        self.layer.cornerRadius = Constants.cornerRadius
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
            make.right.top.equalToSuperview().inset(Constants.spacing)
            make.width.equalTo(self.snp.width).dividedBy(5)
            make.height.equalTo(self.rateBadge.snp.width).multipliedBy(0.75)
        }

        self.nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).offset(Constants.spacing)
            make.left.right.equalToSuperview()
        }
        self.rateLabel.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
}

private extension UpcomingMovieCell {
    private enum Constants {
        static let animationDuration: CGFloat = 0.25
        static let cornerRadius: CGFloat = 12.0
        static let identifier: String = "UpcomingMovieCell"
        static let posterURL: String = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/"
        static let spacing: CGFloat = 9.0
    }
}
