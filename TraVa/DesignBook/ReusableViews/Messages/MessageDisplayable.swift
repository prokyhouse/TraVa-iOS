//
//  MessageDisplayable.swift
//  DesignBook
//
//  Created by Кирилл Прокофьев on 05.04.2023.
//

import Domain
import SwiftMessages
import UIKit

// MARK: - MessageDisplayable

public protocol MessageDisplayable: AnyObject {
    func showMessage(with props: SnackView.SnackProps)
    func showDialog(with props: SandwichView.SandwichProps)
}

public extension MessageDisplayable {
    // MARK: - Public Methods

    func showMessage(with props: SnackView.SnackProps) {
        guard SwiftMessages.sharedInstance.current() == nil else {
            return
        }
        showSnack(props: props)
    }

    func showDialog(with props: SandwichView.SandwichProps) {
        guard SwiftMessages.sharedInstance.current() == nil else {
            return
        }
        showSandwich(props: props)
    }

    func hideCurrentMessageOrDialog() {
        guard SwiftMessages.sharedInstance.current() != nil else {
            return
        }
        SwiftMessages.hide(animated: true)
    }

    // MARK: - Private Methods

    private func showSnack(props: SnackView.SnackProps) {
        let view = SnackView(props: props)
        var config = SwiftMessages.Config()
        config.dimMode = .none
        config.duration = .seconds(seconds: 4)
        config.interactiveHide = true
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.presentationStyle = .top
        SwiftMessages.show(config: config, view: view)
    }

    private func showSandwich(props: SandwichView.SandwichProps) {
        let view = SandwichView(props: props)
        var config = SwiftMessages.Config()
        config.dimMode = .color(color: AppResources.colors.overlay, interactive: false)
        config.duration = .forever
        config.interactiveHide = true
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.presentationStyle = .bottom
        SwiftMessages.show(config: config, view: view)
    }
}

// MARK: - UIViewController

extension UIViewController: MessageDisplayable { }
