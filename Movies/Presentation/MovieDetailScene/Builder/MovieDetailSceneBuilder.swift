//
//  MovieDetailScene.swift
//  Movies
//
//  Created by Владислав Баранкевич on 22.09.2023.
//

import UIKit

enum MovieDetailSceneTransitions: Transition {
    case backToMoviesList
}

final class MovieDetailSceneBuilder {
    static func build(_ container: AppContainer, movieId: Int) -> Module<MovieDetailSceneTransitions, UIViewController> {
        let viewModel = MovieDetailViewModel(movieId: movieId, moviesService: container.moviesService)
        let viewController = MovieDetailViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
