//
//  ViewController.swift
//  TraVa
//
//  Created by Кирилл Прокофьев on 22.12.2021.
//

import UIKit

class MainViewController: UIViewController {

	private var mainView: MainView = MainView()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.systemBackground
	}

	override func loadView() {
		self.view = self.mainView
	}

}
