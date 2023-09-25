//
//  YoutubePlayerSceneBuilder.swift
//  Movies
//
//  Created by Владислав Баранкевич on 23.09.2023.
//

import UIKit

enum YoutubePlayerSceneTransitions: Transition { }

final class YoutubePlayerSceneBuilder {
    static func build(container: AppContainer, trailerKey: MovieTrailerModel) -> Module<YoutubePlayerSceneTransitions, UIViewController> {
        let viewModel = YoutubePlayerViewModel(trailerKey: trailerKey)
        let viewController = YoutubePlayerViewController(viewModel: viewModel)
        
        return Module(
            viewController: viewController,
            transitionPublisher: viewModel.transitionPublisher)
    }
}
