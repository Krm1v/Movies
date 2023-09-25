//
//  MovieDetailScene.swift
//  Movies
//
//  Created by Владислав Баранкевич on 22.09.2023.
//

import UIKit

enum MovieDetailSceneTransitions: Transition {
    case backToMoviesList
    case presentPosterDetailScene(posterPath: String)
    case presentYoutubePlayerScene(trailerKey: MovieTrailerModel)
}

final class MovieDetailSceneBuilder {
    static func build(_ container: AppContainer, movie: MovieDetail) -> Module<MovieDetailSceneTransitions, UIViewController> {
        let viewModel = MovieDetailViewModel(movie: movie, moviesService: container.moviesService)
        let viewController = MovieDetailViewController(viewModel: viewModel)
        
        return Module(
            viewController: viewController,
            transitionPublisher: viewModel.transitionPublisher)
    }
}
