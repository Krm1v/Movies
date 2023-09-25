//
//  MainCoordinator.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import UIKit
import Combine

final class MainCoordinator: Coordinator {
    // MARK: - Properties
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let container: AppContainer
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    // MARK: - Public methods
    func start() {
        startMoviesListScene()
    }
}

// MARK: - Private extension
private extension MainCoordinator {
    func startMoviesListScene() {
        let module = MoviesListSceneBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .openDetail(let movie):
                    openDetailScene(movie: movie)
                }
            }
            .store(in: &cancellables)
        setRoot([module.viewController])
    }
    
    func openDetailScene(movie: MovieDetail) {
        let module = MovieDetailSceneBuilder.build(container, movie: movie)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .backToMoviesList:
                    pop()
                case .presentPosterDetailScene(let posterPath):
                    openPosterDetailScene(posterPath: posterPath)
                case .presentYoutubePlayerScene(let trailerKey):
                    openYoutubePlayerScene(trailerKey: trailerKey)
                }
            }
            .store(in: &cancellables)
        push(module.viewController)
    }
    
    func openPosterDetailScene(posterPath: String) {
        let module = PosterDetailSceneBuilder.build(
            container,
            posterPath: posterPath)
        
        module.transitionPublisher
            .sink { _ in }
            .store(in: &cancellables)
        presentScene(module.viewController)
    }
    
    func openYoutubePlayerScene(trailerKey: MovieTrailerModel) {
        let module = YoutubePlayerSceneBuilder.build(
            container: container,
            trailerKey: trailerKey)
        
        module.transitionPublisher
            .sink { _ in }
            .store(in: &cancellables)
        presentScene(module.viewController)
    }
}
