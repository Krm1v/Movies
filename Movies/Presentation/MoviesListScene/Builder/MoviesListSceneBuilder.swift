//
//  MoviesListSceneBuilder.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import UIKit

enum MoviesListSceneTransitions: Transition {
    case openDetail(movie: MovieDetail)
}

final class MoviesListSceneBuilder {
    static func build(container: AppContainer) -> Module<MoviesListSceneTransitions, UIViewController> {
        let viewModel = MoviesListSceneViewModel(
            moviesService: container.moviesService,
            moviesCacheService: container.moviesCacheService)
        
        let viewController = MoviesListSceneViewController(viewModel: viewModel)
        
        return Module(
            viewController: viewController,
            transitionPublisher: viewModel.transitionPublisher)
    }
}
