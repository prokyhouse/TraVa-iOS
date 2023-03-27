//
//  ActorView.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 28.12.2021.
//

import Common
import Domain
import DesignBook
import UIKit
import SnapKit

public final class ActorView: UIView {
    // MARK: - Views

    private(set) lazy var navBar: BlurNavigationBar = {
        let navBar = BlurNavigationBar()
        return navBar
    }()

    private lazy var photoView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true

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
        description.textAlignment = .left
        description.adjustsFontSizeToFitWidth = true
        description.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)

        return description
    }()

    private lazy var infoView: UIView = {
        let view = UIView()
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerRadius = 32.0
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
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
                                        colorBottom: .black,
                                        startY: 0.6,
                                        endY: 1.0)
    }

    // MARK: View Props

    struct Props: Equatable {
        public let actor: Cast

        public init(actor: Cast) {
            self.actor = actor
        }
    }

    // MARK: - Public methods

    func render(props: Props) {
        if props.actor.profilePath == nil {
            photoView.image = Constants.templateImage
        } else {
            photoView.download(from: Constants.urlBase + props.actor.profilePath!)
        }

        navBar.title = props.actor.name
        descriptionLabel.attributedText = makeDescription(
            id: props.actor.id,
            gender: props.actor.gender,
            character: props.actor.character
        )
    }
}

// MARK: - Private methods

private extension ActorView {
    func configure() {
        setConfig()
        addSubviews()
        setConstraints()
    }

    func setConfig() {
        backgroundColor = .systemBackground
    }

    func addSubviews() {
        addSubview(navBar)
        addSubview(photoView)
        addSubview(infoView)
        infoView.addSubview(descriptionLabel)
        bringSubviewToFront(navBar)
    }

    func setConstraints() {
        NSLayoutConstraint.useAndActivateConstraints([
            navBar.leftAnchor.constraint(equalTo: leftAnchor),
            navBar.rightAnchor.constraint(equalTo: rightAnchor),
            navBar.topAnchor.constraint(equalTo: topAnchor)
        ])

        NSLayoutConstraint.useAndActivateConstraints([
            photoView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -32.0),
            photoView.leftAnchor.constraint(equalTo: leftAnchor),
            photoView.rightAnchor.constraint(equalTo: rightAnchor),
            photoView.heightAnchor.constraint(equalToConstant: Constants.screenWidth)
        ])

        NSLayoutConstraint.useAndActivateConstraints([
            infoView.topAnchor.constraint(equalTo: photoView.bottomAnchor),
            infoView.leftAnchor.constraint(equalTo: leftAnchor),
            infoView.rightAnchor.constraint(equalTo: rightAnchor),
            infoView.bottomAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor,
                constant: Constants.hSpacing / 2
            )
        ])

        NSLayoutConstraint.useAndActivateConstraints([
            descriptionLabel.topAnchor.constraint(equalTo: infoView.topAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: Constants.hSpacing),
            descriptionLabel.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -Constants.hSpacing),
        ])
    }

    func makeDescription(id: Int?, gender: Gender?, character: String?) -> NSAttributedString {
        let description = NSMutableAttributedString()
        let boldAttributes:[NSAttributedString.Key : Any] = [
            .foregroundColor: Appearance.accentColor,
            .font : UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        let normalAttributes:[NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 18, weight: .regular)
        ]

        if let id = id {
            description.append(NSAttributedString(string: Constants.id, attributes: boldAttributes))
            description.append(NSAttributedString(string: "\(id) \n", attributes: normalAttributes))
        }
        if let gender = gender {
            description.append(NSAttributedString(string: Constants.gender, attributes: boldAttributes))
            description.append(NSAttributedString(string: "\(gender.asString()) \n", attributes: normalAttributes))
        }
        if let character = character {
            description.append(NSAttributedString(string: Constants.role, attributes: boldAttributes))
            description.append(NSAttributedString(string: "\(character) \n", attributes: normalAttributes))
        }

        return description
    }
}

// MARK: - Constants

private extension ActorView {
    enum Constants {
        static let hSpacing: CGFloat = 32.0
        static let screenWidth = UIScreen.main.bounds.size.width
        static let templateImage: UIImage? = UIImage(named: "ActorTemplate")
        static let urlBase: String = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/"

        static let id: String = "ID: "
        static let gender: String = "Пол: "
        static let role: String = "Роль: "
    }

    enum Appearance {
        static let accentColor: UIColor = UIColor(named: "AccentColor") ?? .systemPurple
    }
}
