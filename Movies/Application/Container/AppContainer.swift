//
//  Container.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import Foundation

protocol AppContainer: AnyObject {
    var appConfiguration: AppConfiguration { get }
}

final class AppContainerImpl: AppContainer {
    // MARK: - Properties
    let appConfiguration: AppConfiguration
    
    // MARK: - Init
    init() {
        let appConfiguration = AppConfigurationImpl()
        self.appConfiguration = appConfiguration
    }
}
