//
//  SceneDelegate.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Properties
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var container: AppContainer?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        self.window = UIWindow(windowScene: windowScene)
        self.container = AppContainerImpl()
        guard
            let window = window,
            let container = container
        else {
            return
        }
        self.appCoordinator = AppCoordinator(
            window: window,
            container: container)
        
        self.container = container
        self.appCoordinator?.start()
    }
}

