//
//  UIView+Gradient.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 25.12.2021.
//

import Foundation
import UIKit

extension UIView {
	func setGradientBackground(colorTop: UIColor, colorBottom: UIColor, cornerRadius: CGFloat) {

		if let _ = (self.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
			removeSublayer(self, layerIndex: 0)
		}

		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = self.bounds
		gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
		gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
		gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
		gradientLayer.cornerRadius = cornerRadius
		self.layer.insertSublayer(gradientLayer, at: 0)

	}

	func setGradientBackground(colorTop: UIColor, colorBottom: UIColor, startY: Double, endY: Double) {
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = self.bounds
		gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
		gradientLayer.startPoint = CGPoint(x: 0.0, y: startY)
		gradientLayer.endPoint = CGPoint(x: 0.0, y: endY)
		self.layer.insertSublayer(gradientLayer, at: 0)
	}

	func removeSublayer(_ view: UIView, layerIndex index: Int) {
		guard let sublayers = view.layer.sublayers else { return }
		if sublayers.count > index {
			view.layer.sublayers?.remove(at: index)
		}
	}
}
