//
//  MovieDetailViewModel.swift
//  Movies
//
//  Created by Владислав Баранкевич on 22.09.2023.
//

import Foundation
import Combine

final class MovieDetailViewModel: BaseViewModel {
    // MARK: - Properties
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<MovieDetailSceneTransitions, Never>()
    private let moviesService: MoviesService
    private var movie: MovieDetail
    @Published var datasource: MovieDetailModel?
    
    // MARK: - Init
    init(movie: MovieDetail, moviesService: MoviesService) {
        self.movie = movie
        self.moviesService = moviesService
    }
    
    // MARK: - Overriden methods
    override func onViewWillAppear() {
        updateDatasource()
    }
    
    // MARK: - Public methods
    func openPosterDetailScene() {
        transitionSubject.send(.presentPosterDetailScene(posterPath: movie.posterPath))
    }
    
    func openYoutubePlayerScene() {
        let movieTrailerModel = MovieTrailerModel(key: movie.video ?? "")
        transitionSubject.send(.presentYoutubePlayerScene(trailerKey: movieTrailerModel))
    }
}

// MARK: - Private extension
private extension MovieDetailViewModel {
    func updateDatasource() {
        datasource = .init(movie)
    }
}
