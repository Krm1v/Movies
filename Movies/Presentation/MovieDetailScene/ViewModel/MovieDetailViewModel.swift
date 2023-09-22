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
    private let movieId: Int
    private var movie: MovieDetail?
    @Published var datasource: MovieDetailModel?
    
    // MARK: - Init
    init(movieId: Int, moviesService: MoviesService) {
        self.movieId = movieId
        self.moviesService = moviesService
    }
    
    // MARK: - Overriden methods
    override func onViewDidLoad() {
        fetchMovieDetailsRequest(movieId: movieId)
    }
}

// MARK: - Private extension
private extension MovieDetailViewModel {
    func updateDatasource() {
        guard let movie = movie else {
            return
        }
        datasource = .init(movie)
    }
    
    // MARK: - Network requests calling
    func fetchMovieDetailsRequest(movieId: Int) {
        moviesService.fetchMovieDetails(movieId: movieId)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else {
                    return
                }
                switch completion {
                case .finished:
                    Logger.info("Details fetched")
                    self.updateDatasource()
                case .failure(let error):
                    Logger.error(error.localizedDescription)
                    errorSubject.send(error)
                }
            } receiveValue: { [weak self] movie in
                guard let self = self else {
                    return
                }
                self.movie = movie
            }
            .store(in: &cancellables)
    }
}
