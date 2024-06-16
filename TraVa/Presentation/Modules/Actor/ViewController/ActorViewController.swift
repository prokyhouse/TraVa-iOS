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
    public var presenter: ActorPresenter?
    
    private let actorView = ActorView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchActor()
    }
    
    public override func loadView() {
        actorView.navBar.delegate = self
        self.view = self.actorView
    }
    
    public func setActor(_ actor: Cast) {
        actorView.render(props: .init(actor: actor))
    }
}

extension ActorViewController: BlurNavigationBarDelegate {
    public func onBackTap() {
        navigationController?.popViewController(animated: true)
    }
}
