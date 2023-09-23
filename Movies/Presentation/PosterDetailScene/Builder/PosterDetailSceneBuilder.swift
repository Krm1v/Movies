//
//  PosterDetailSceneBuilder.swift
//  Movies
//
//  Created by Владислав Баранкевич on 22.09.2023.
//

import UIKit

enum PosterDetailSceneTransitions: Transition {}

final class PosterDetailSceneBuilder {
    static func build(_ container: AppContainer, posterPath: String) -> Module<PosterDetailSceneTransitions, UIViewController> {
        let viewModel = PosterDetailSceneViewModel(posterPath: posterPath)
        let viewController = PosterDetailSceneViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
