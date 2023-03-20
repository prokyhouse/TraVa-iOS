//
//  ActorView.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 28.12.2021.
//

import Common
import Domain
import UIKit
import SnapKit

public final class ActorView: UIView {
    // MARK: - Views

    private lazy var photoView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill

        return view
    }()

    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.bold)

        return title
    }()

    private lazy var descriptionLabel: UILabel = {
        let description = UILabel()
        description.textColor = .white
        description.numberOfLines = 4
        description.textAlignment = .center
        description.adjustsFontSizeToFitWidth = true

        return description
    }()

    private let contentView = UIView()

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
        contentView.setGradientBackground(colorTop: .black ,
                                               colorBottom: UIColor.clear,
                                               startY: 0.4,
                                               endY: .zero)
    }

    // MARK: - Public methods

    func setContent(actor: Cast) {
        if actor.profilePath == nil {
            photoView.image = Constants.templateImage
        } else {
            photoView.imageFromUrl(urlString: Constants.urlBase + actor.profilePath!)
        }

        titleLabel.text = actor.name
        descriptionLabel.text = actor.character
    }
}

// MARK: - Private methods

private extension ActorView {
    private func configure() {
        setConfig()
        addSubviews()
        setConstraints()
    }

    private func setConfig() {
        backgroundColor = .systemBackground
    }

    private func addSubviews() {
        addSubview(photoView)
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }

    private func setConstraints() {
        self.photoView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-260)
            make.height.lessThanOrEqualTo(Constants.maxPhotoHeight)
        }

        self.contentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(self.photoView.snp.bottom).offset(-170)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Constants.spaceBetweenComponents)
            make.top.equalTo(self.contentView.snp.top).offset(84)
            make.height.equalTo(Constants.titleLabelHeight)
            make.centerX.equalTo(self.contentView.snp.centerX)
        }

        self.descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.contentView.snp.centerX)
            make.left.right.equalTo(self.contentView).inset(Constants.spaceBetweenComponents)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Constants.spaceBetweenComponents)
        }
    }
}

// MARK: - Constants

private extension ActorView {
    enum Constants {
        static let spaceBetweenComponents: CGFloat = 20.0
        static let viewHeight: CGFloat = 960.0
        static let titleLabelHeight: CGFloat = 30.0
        static let maxPhotoHeight: CGFloat = 650.0

        static let templateImage: UIImage? = UIImage(named: "ActorTemplate")

        static let urlBase: String = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/"
    }
}
