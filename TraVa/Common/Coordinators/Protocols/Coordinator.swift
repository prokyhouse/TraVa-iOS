//
//  Coordinator.swift
//
//  Created by Kirill Prokofyev on 27.03.2023.
//

import UIKit

public protocol Coordinator: AnyObject {
    // MARK: - Properties
    var rootViewController: UIViewController { get }

    var children: [Coordinator] { get }

    // MARK: - Methods
    func start()
}
