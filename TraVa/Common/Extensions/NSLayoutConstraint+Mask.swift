//
//  NSLayoutConstraint+Mask.swift
//  Common
//
//  Created by Кирилл Прокофьев on 20.03.2023.
//

import UIKit

public extension NSLayoutConstraint {
    class func useAndActivateConstraints(_ constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            if let view = constraint.firstItem as? UIView {
                view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        activate(constraints)
    }
}
