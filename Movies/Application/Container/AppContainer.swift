//
//  Container.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import Foundation

protocol AppContainer: AnyObject {
    var appConfiguration: AppConfiguration { get }
    var moviesNetworkService: MoviesNetworkService { get }
    var moviesService: MoviesService { get }
}

final class AppContainerImpl: AppContainer {
    // MARK: - Properties
    let appConfiguration: AppConfiguration
    let moviesNetworkService: MoviesNetworkService
    let moviesService: MoviesService
    
    // MARK: - Init
    init() {
        let appConfiguration = AppConfigurationImpl()
        self.appConfiguration = appConfiguration
        
        let networkManager = NetworkManager()
        
        let moviesNetworkProvider = NetworkServiceProviderImpl<MoviesEndpoint>(
            baseURLStorage: appConfiguration,
            networkManager: networkManager,
            decoder: JSONDecoder())
        
        let moviesNetworkService = MoviesNetworkServiceImpl(moviesNetworkProvider)
        self.moviesNetworkService = moviesNetworkService
        
        let moviesService = MoviesServiceImpl(moviesNetworkService: moviesNetworkService)
        self.moviesService = moviesService
    }
}
