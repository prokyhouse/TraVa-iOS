//
//  PrimaryButton.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 14.04.2023.
//

import UIKit

public enum PrimaryButtonStyle: Equatable {
    case bordered
    case filled
    case none
}

public class PrimaryButton: UIButton {
    // MARK: - Public Properties

    public var style: PrimaryButtonStyle = .filled {
        didSet {
            applyStyle(style)
        }
    }

    public var title: String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }

    public var icon: UIImage? {
        didSet {
            setImage(icon?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }

    override public var isEnabled: Bool {
        didSet {
            applyStyle(style)
        }
    }

    public var onTap: () -> Void = { }

    // MARK: - Lifecycle

    public init() {
        super.init(frame: .zero)
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: View lifecycle

    override public func layoutSubviews() {
        super.layoutSubviews()
        applyStyle(style)
    }
}

// MARK: - Private Methods
private extension PrimaryButton {
    func configure() {
        clipsToBounds = true
        semanticContentAttribute = .forceRightToLeft
        titleLabel?.font = AppResources.fonts.ssPro.semibold.ofSize(Constants.fontSize)

        contentEdgeInsets = UIEdgeInsets(
            top: Constants.verticalInset,
            left: Constants.horizontalInset,
            bottom: Constants.verticalInset,
            right: Constants.horizontalInset
        )

        titleEdgeInsets = UIEdgeInsets(
            top: .zero,
            left: .zero,
            bottom: .zero,
            right: Constants.spacing
        )

        setupAction()
    }

    func applyStyle(_ style: PrimaryButtonStyle) {
        let palette = AppResources.colors
        layer.cornerRadius = frame.height / 2.0

        switch style {
        case .bordered:
            layer.borderWidth = Constants.borderWidth
            backgroundColor = .clear
            layer.borderColor = palette.accent.cgColor
            setTitleColor(palette.accent, for: .normal)
            tintColor = palette.accent

        case .filled:
            layer.borderWidth = .zero
            backgroundColor = isEnabled ? palette.accent : palette.inactive
            tintColor = palette.background
            setTitleColor(palette.background, for: .normal)

        case .none:
            layer.borderWidth = .zero
            backgroundColor = .clear
            tintColor = isEnabled ? palette.accent : palette.inactive
            setTitleColor(palette.accent, for: .normal)
        }
    }

    func setupAction() {
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    @objc
    func handleTap() {
        onTap()
    }
}

// MARK: - Constants

private extension PrimaryButton {
    enum Constants {
        static let iconSize: CGFloat = 24.0
        static let fontSize: CGFloat = 18.0
        static let verticalInset: CGFloat = 16.0
        static let horizontalInset: CGFloat = 16.0
        static let spacing: CGFloat = 12.0
        static let borderWidth: CGFloat = 1.5
    }
}
