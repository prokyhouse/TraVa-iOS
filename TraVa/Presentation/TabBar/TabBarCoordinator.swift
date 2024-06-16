//
//  TabBarCoordinator.swift
//  Presentation
//
//  Created by Кирилл Прокофьев on 27.03.2023.
//

import Common
import DesignBook
import Domain
import Networking
import UIKit

public protocol TabBarCoordinatorProtocol: BaseNavigationCoordinator {
    var onCompleted: (() -> Void)? { get set }
    func goToPopular()
    func goToUpcoming()
    func goToMovieDetails(_ id: Int)
    func goToActorDetails(_ actor: Cast)
    func goBack()
}

public final class TabBarCoordinator: BaseNavigationCoordinator, TabBarCoordinatorProtocol {
    // MARK: - Public Properties

    public var onCompleted: (() -> Void)?

    // MARK: - Private Properties

    private var tabBarController: TabBarController = .init()
    private let networkService: Networkable = NetworkService()

    // MARK: - Lifecycle

    override public func start() {
        initializeTabBar()
    }

    // MARK: - Screens

    public func initializeTabBar() {
        let pages: [TabBarPage] = [.main, .popular, .upcoming]
        let controllers: [UINavigationController] = pages.map({ getTabController(for: $0) })
        setupTabBar(with: controllers)
    }

    // MARK: - Flows

    public func goToPopular() {
        tabBarController.selectedIndex = TabBarPage.popular.rawValue
    }

    public func goToUpcoming() {
        tabBarController.selectedIndex = TabBarPage.upcoming.rawValue
    }

    public func goToMovieDetails(_ id: Int) {
        let viewController = MovieViewController()
        let presenter = MovieViewPresenter(
            viewController: viewController,
            coordinator: self,
            networkService: networkService,
            movieID: id
        )
        viewController.presenter = presenter
        navigationController.pushViewController(viewController, animated: true)
    }

    public func goToActorDetails(_ actor: Cast) {
        let viewController = ActorViewController()
        let presenter = ActorViewPresenter(
            viewController: viewController,
            coordinator: self,
            actor: actor
        )
        viewController.presenter = presenter
        navigationController.pushViewController(viewController, animated: true)
    }

    public func goBack() {
        navigationController.popViewController(animated: true)
    }
}

private extension TabBarCoordinator {
    func setupTabBar(with tabControllers: [UIViewController]) {
        tabBarController.selectedIndex = TabBarPage.main.rawValue
        tabBarController.setViewControllers(tabControllers, animated: false)

        navigationController.viewControllers = [tabBarController]
    }

    func getTabController(for tab: TabBarPage) -> UINavigationController {
        var viewController: UIViewController

        switch tab {
            case .main:
                viewController = makeMain()

            case .popular:
                viewController = makePopular()

            case .upcoming:
                viewController = makeUpcoming()
        }

        viewController.title = tab.getTitle(full: true)
        viewController.tabBarItem = .init(
            title: tab.getTitle(),
            image: tab.getIcon(for: .unselected),
            selectedImage: tab.getIcon(for: .selected)
        )
        return UINavigationController(rootViewController: viewController)
    }

    func makeMain() -> UIViewController {
        let viewController = MainViewController()
        let presenter = MainViewPresenter(
            viewController: viewController,
            coordinator: self,
            networkService: networkService
        )
        viewController.presenter = presenter
        return viewController
    }

    func makeUpcoming() -> UIViewController {
        let viewController = UpcomingViewController()
        let presenter = UpcomingViewPresenter(
            viewController: viewController,
            coordinator: self,
            networkService: networkService
        )
        viewController.presenter = presenter
        return viewController
    }

    func makePopular() -> UIViewController {
        let viewController = PopularViewController()
        let presenter = PopularViewPresenter(
            viewController: viewController,
            coordinator: self,
            networkService: networkService
        )
        viewController.presenter = presenter
        return viewController
    }
}
