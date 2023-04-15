//
//  SandwichView.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 10.04.2023.
//

import Foundation

import SwiftMessages
import UIKit

public final class SandwichView: BaseView {
    // MARK: - Nested

    public struct SandwichProps {
        let title: String
        let subtitle: String
        let buttons: [SandwichButton]

        public init(title: String, subtitle: String, buttons: [SandwichButton]) {
            self.title = title
            self.subtitle = subtitle
            self.buttons = buttons
        }
    }

    public struct SandwichButton {
        let text: String
        let style: PrimaryButtonStyle
        let action: () -> Void

        public init(text: String, style: PrimaryButtonStyle, action: @escaping () -> Void) {
            self.text = text
            self.style = style
            self.action = action
        }
    }

    // MARK: - Views

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppResources.fonts.ssPro.semibold.ofSize(30)
        label.textColor = AppResources.colors.accent
        label.numberOfLines = 0
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppResources.fonts.ssPro.regular.ofSize(13)
        label.textColor = AppResources.colors.text
        label.numberOfLines = 0
        return label
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        return stackView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20.0
        view.clipsToBounds = true
        view.backgroundColor = AppResources.colors.background
        return view
    }()

    // MARK: - Lifecycle

    init(props: SandwichProps) {
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
        configureMessage(props)
        configureButtons(props.buttons)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension SandwichView {
    func addSubviews() {
        installBackgroundView(
            contentView,
            insets: .init(top: .zero, left: Constants.inset, bottom: Constants.inset, right: Constants.inset)
        )
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(buttonsStackView)
    }

    func setupConstraints() {
        NSLayoutConstraint.useAndActivateConstraints([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),

            buttonsStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24.0),
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.0)
        ])
    }

    func configureMessage(_ props: SandwichProps) {
        titleLabel.text = props.title
        subtitleLabel.text = props.subtitle
    }

    func configureButtons(_ buttons: [SandwichButton]) {
        buttons.forEach { buttonProps in
            let button = PrimaryButton()
            button.style = buttonProps.style
            button.title = buttonProps.text
            button.onTap = buttonProps.action
            button.isEnabled = true
            buttonsStackView.addArrangedSubview(button)
        }
    }
}

// MARK: - Consntants

private extension SandwichView {
    enum Constants {
        static let horizontalSpacing: CGFloat = 19.5
        static let iconSize: CGFloat = 24.0
        static let inset: CGFloat = 16.0
    }
}
