//
//  BlurNavigationBar.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 20.03.2023.
//

import UIKit
import Common

public protocol BlurNavigationBarDelegate: AnyObject {
    func onBackTap()
}

public final class BlurNavigationBar: UIView {
    // MARK: - Properties

    public weak var delegate: BlurNavigationBarDelegate?

    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    // MARK: - Views

    private lazy var contentView = UIView()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.backIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(backButtonWasTapped), for: .touchUpInside)
        button.tintColor = UIColor(named: "AccentColor") ?? .systemPurple

        return button
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.bold)
        titleLabel.textColor = UIColor(named: "AccentColor") ?? .systemPurple
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 3
        titleLabel.lineBreakMode = .byTruncatingTail

        return titleLabel
    }()

    private let blurView: BlurView = .init()

    // MARK: - Lifecycle

    public init() {
        super.init(frame: .zero)

        addSubviews()
        setupConstraints()
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension BlurNavigationBar {
    func addSubviews() {
        addSubview(blurView)
        blurView.contentView.addSubview(contentView)
        contentView.addSubview(backButton)
        contentView.addSubview(titleLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.useAndActivateConstraints([
            blurView.leftAnchor.constraint(equalTo: leftAnchor),
            blurView.rightAnchor.constraint(equalTo: rightAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        NSLayoutConstraint.useAndActivateConstraints([
            contentView.leftAnchor.constraint(equalTo: blurView.leftAnchor, constant: Constants.horizontalSpacing),
            contentView.rightAnchor.constraint(equalTo: blurView.rightAnchor, constant: -Constants.horizontalSpacing),
            contentView.topAnchor.constraint(equalTo: blurView.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            contentView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -20.0)
            // contentView.heightAnchor.constraint(equalToConstant: 36.0)
        ])

        NSLayoutConstraint.useAndActivateConstraints([
            backButton.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            backButton.heightAnchor.constraint(equalToConstant: Constants.buttonsSize),
            backButton.widthAnchor.constraint(equalToConstant: Constants.buttonsSize)
        ])

        NSLayoutConstraint.useAndActivateConstraints([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: backButton.rightAnchor, constant: Constants.horizontalSpacing),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure() {
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = Constants.cornerRadius
        layer.cornerCurve = .continuous
        clipsToBounds = true
    }

    @objc
    func backButtonWasTapped() {
        delegate?.onBackTap()
    }
}

// MARK: - Consntants

private extension BlurNavigationBar {
    enum Constants {
        static let buttonsSize: CGFloat = 24.0
        static let cornerRadius: CGFloat = 32.0
        static let horizontalSpacing: CGFloat = 16.0
        static let backIcon: UIImage? = UIImage(named: "backArrow")
    }
}
