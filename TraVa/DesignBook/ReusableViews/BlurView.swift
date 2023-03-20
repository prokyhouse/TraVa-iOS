//
//  BlurView.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 20.03.2023.
//

import UIKit

public final class BlurView: UIVisualEffectView {
    // MARK: Public Properties

    /// Плотность размытия.
    public var intensity: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: Private Properties

    private let blur = UIBlurEffect(style: .regular)
    private var animator: UIViewPropertyAnimator?

    // MARK: Lifecycle

    public init() {
        super.init(effect: blur)
    }

    @available(*, unavailable)
    override public init(effect: UIVisualEffect?) { fatalError("Unavailable") }

    @available(*, unavailable)
    public init(frame: CGRect) { fatalError("Unavailable") }

    @available(*, unavailable)
    public required init?(coder: NSCoder) { nil }

    deinit {
        animator?.stopAnimation(true)
    }

    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1.0, curve: .linear) { [weak self] in
            self?.effect = self?.blur
        }
        animator?.fractionComplete = intensity
    }
}
