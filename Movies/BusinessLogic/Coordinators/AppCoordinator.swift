//
//  AppCoordinator.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import UIKit
import Combine

final class AppCoordinator: Coordinator {
    // MARK: - Properties
    var window: UIWindow
    var navigationController: UINavigationController
    let container: AppContainer
    var childCoordinators: [Coordinator] = []
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        window: UIWindow,
        navigationController: UINavigationController = UINavigationController(),
        container: AppContainer
    ) {
        self.window = window
        self.navigationController = navigationController
        self.container = container
    }
    
    // MARK: - Public methods
    func start() {
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
        startMainCoordinator()
    }
}

// MARK: - Private extension
private extension AppCoordinator {
    func startMainCoordinator() {
        let mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            container: container)
        childCoordinators.append(mainCoordinator)
        mainCoordinator.didFinishPublisher
            .sink { [unowned self] in
                removeChild(coordinator: mainCoordinator)
            }
            .store(in: &cancellables)
        mainCoordinator.start()
    }
}
