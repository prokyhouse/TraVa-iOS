//
//  ActorViewController.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 28.12.2021.
//

import Domain
import Foundation
import UIKit
import DesignBook

public final class ActorViewController: UIViewController {
    private let actorView = ActorView()
    private let actor: Cast

    init(actor: Cast) {
        self.actor = actor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func loadView() {
        self.actorView.setContent(actor: self.actor)
        actorView.navBar.delegate = self
        self.view = self.actorView
    }
}

extension ActorViewController: BlurNavigationBarDelegate {
    public func onBackTap() {
        navigationController?.popViewController(animated: true)
    }
}
