//
//  ViewModel.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import Foundation
import Combine

final class MoviesListSceneViewModel: BaseViewModel {
    // MARK: - Typealiases
    typealias MoviesSectionModel = SectionModel<MoviesListSceneSections, MoviesListSceneItems>
    
    // MARK: - Properties
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<MoviesListSceneTransitions, Never>()
    private let moviesService: MoviesService
    private var pageCount = 1
    private var movies: [Movie] = []
    
    // MARK: - Published properties
    @Published var sections: [MoviesSectionModel] = []
    @Published var isRefreshing = false
    
    // MARK: - Init
    init(moviesService: MoviesService) {
        self.moviesService = moviesService
    }
    
    // MARK: - Overriden methods
    override func onViewDidLoad() {
        fetchTopRatedMovies()
    }
    
    override func onViewWillAppear() {
        updateDatasource()
    }
    
    // MARK: - Public methods
    func fetchTopRatedMovies() {
        fetchTopRatedMoviesRequest()
    }
    
    func fetchPopularMovies() {
        fetchPopularMoviesRequest()
    }
    
    func searchMovie(movieTitle: String) {
        searchMovieRequest(movieTitle: movieTitle)
    }
    
    func resetToDefaultValues() {
        pageCount = 1
        movies = []
    }
    
    func openDetailScene(with movieId: Int) {
        transitionSubject.send(.openDetail(movieId: movieId))
    }
}

// MARK: - Private extension
private extension MoviesListSceneViewModel {
    // MARK: - Update datasource method
    func updateDatasource() {
        let movieCellModel = movies.map { movie in
            MoviesListSceneCellModel(movie)
        }
        var mainSection = MoviesSectionModel(
            section: .main,
            items: [])
        mainSection.items = movieCellModel.map({ model in
                .movie(model)
        })
        
        sections = [mainSection]
    }
    
    // MARK: - Network requests calling
    func fetchTopRatedMoviesRequest() {
        isLoadingSubject.send(true)
        moviesService.fetchTopRatedMovies(page: pageCount)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else {
                    return
                }
                switch completion {
                case .finished:
                    Logger.info("Movies fetched")
                    self.updateDatasource()
                    if !isRefreshing {
                        self.pageCount += 1
                    }
                case .failure(let error):
                    errorSubject.send(error)
                    Logger.error(error.localizedDescription)
                }
            } receiveValue: { [weak self] movies in
                guard let self = self else {
                    return
                }
                self.movies.append(contentsOf: movies)
                isLoadingSubject.send(false)
                isRefreshing = false
            }
            .store(in: &cancellables)
    }
    
    func fetchPopularMoviesRequest() {
        isLoadingSubject.send(true)
        moviesService.fetchPopularMovies(page: pageCount)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else {
                    return
                }
                switch completion {
                case .finished:
                    Logger.info("Finished")
                    self.updateDatasource()
                    if !isRefreshing {
                        self.pageCount += 1
                    }
                case .failure(let error):
                    Logger.error(error.localizedDescription)
                    errorSubject.send(error)
                }
            } receiveValue: { [weak self] movies in
                guard let self = self else {
                    return
                }
                self.movies.append(contentsOf: movies)
                isLoadingSubject.send(false)
                isRefreshing = false
            }
            .store(in: &cancellables)
    }
    
    func searchMovieRequest(movieTitle: String) {
        isLoadingSubject.send(true)
        moviesService.searchMovie(title: movieTitle)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else {
                    return
                }
                switch completion {
                case .finished:
                    Logger.info("Searched")
                    self.updateDatasource()
                case .failure(let error):
                    Logger.error(error.localizedDescription)
                    errorSubject.send(error)
                }
            } receiveValue: { [weak self] movies in
                guard let self = self else {
                    return
                }
                self.movies = movies
                isLoadingSubject.send(false)
            }
            .store(in: &cancellables)
    }
}
