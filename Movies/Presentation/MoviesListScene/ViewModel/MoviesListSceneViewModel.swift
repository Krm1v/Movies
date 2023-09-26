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
    
    enum MoviesSortingParameters {
        case topRated
        case popular
        
        var screenTitle: String {
            switch self {
            case .topRated:
                return Localization.topRated
            case .popular:
                return Localization.popularMovies
            }
        }
    }
    
    // MARK: - Properties
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<MoviesListSceneTransitions, Never>()
    private let moviesService: MoviesService
    private let moviesCacheService: MoviesCacheService
    private var pageCount = 1
    private var movie: MovieDetail?
    private var isInternetAvailable = true
    var sortingParameters: MoviesSortingParameters = .popular
    
    // MARK: - Published properties
    @Published private var cachedMovies: [Movie] = []
    @Published private var movies: [Movie] = []
    @Published var sections: [MoviesSectionModel] = []
    @Published private var genres: [Genre] = []
    @Published var isRefreshing = false
    @Published var isMoviesEmpty = true
    @Published var isCachedMoviesEmpty = true
    
    // MARK: - Init
    init(
        moviesService: MoviesService,
        moviesCacheService: MoviesCacheService
    ) {
        self.moviesService = moviesService
        self.moviesCacheService = moviesCacheService
    }
    
    // MARK: - Overriden methods
    override func onViewDidLoad() {
        self.checkCurrentInternetConnectionStatus()
        self.checkMoviesList()
        self.fetchGenresRequest()
    }
    
    // MARK: - Public methods
    func fetchTopRatedMovies() {
        self.fetchTopRatedMoviesRequest()
    }
    
    func fetchPopularMovies() {
        self.fetchPopularMoviesRequest()
    }
    
    func searchMovie(movieTitle: String) {
        if isInternetAvailable {
            if !movieTitle.isEmpty {
                searchMovieRequest(movieTitle: movieTitle)
            } else {
                resetToDefaultValues()
                sortingParameters == .topRated ? fetchTopRatedMovies() : fetchPopularMovies()
            }
        } else {
            searchMovieLocaly(movieTitle: movieTitle)
        }
    }
    
    func resetToDefaultValues() {
        pageCount = 1
        movies = []
    }
    
    func openDetailScene(with movieId: Int) {
        self.fetchMovieDetailsRequest(movieId: movieId)
    }
    
    func refreshMovies(
        isRefreshing: Bool,
        completion: @escaping () -> Void
    ) {
        if isRefreshing {
            checkConnection { [weak self] in
                guard let self = self else {
                    return
                }
                completion()
            }
            
            if movies.isEmpty {
                pageCount = 1
                sortingParameters == .topRated ? fetchTopRatedMovies() : fetchPopularMovies()
            }
            
            if !self.isRefreshing {
                completion()
            }
        } else {
            self.isRefreshing = isRefreshing
            completion()
        }
    }
    
    func tableViewDidReachedBottom() {
        checkConnection()
        if !isMoviesEmpty {
            sortingParameters == .topRated ? fetchTopRatedMovies() : fetchPopularMovies()
        }
    }
    
    // MARK: - Deinit
    deinit {
        moviesCacheService.clearMoviesCache()
        cachedMovies.removeAll()
        movies.removeAll()
        cancellables.removeAll()
    }
}

// MARK: - Private extension
private extension MoviesListSceneViewModel {
    // MARK: - Update datasource method
    func updateDatasource() {
        let genreDictionary = Dictionary(uniqueKeysWithValues: genres.map { ($0.id, $0.name) })
        
        let moviesSource = isInternetAvailable ? movies : cachedMovies
        
        let movieCellModel = moviesSource.map { movie in
            var movieModel = MoviesListSceneCellModel(movie)
            let movieGenres = movie.genres.map { genreId in
                return genreDictionary[genreId] ?? ""
            }
            movieModel.genre = movieGenres
            return movieModel
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
        checkConnection()
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
                    addPage()
                case .failure(let error):
                    errorSubject.send(error)
                    isLoadingSubject.send(false)
                    Logger.error(error.localizedDescription)
                }
            } receiveValue: { [weak self] movies in
                guard let self = self else {
                    return
                }
                self.movies.append(contentsOf: movies)
                self.moviesCacheService.cacheMovies(movies: movies)
                isLoadingSubject.send(false)
                isRefreshing = false
            }
            .store(in: &cancellables)
    }
    
    func fetchPopularMoviesRequest() {
        checkConnection()
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
                    addPage()
                case .failure(let error):
                    Logger.error(error.localizedDescription)
                    errorSubject.send(error)
                    isLoadingSubject.send(false)
                }
            } receiveValue: { [weak self] movies in
                guard let self = self else {
                    return
                }
                self.movies.append(contentsOf: movies)
                self.moviesCacheService.cacheMovies(movies: movies)
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
                    isLoadingSubject.send(false)
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
    
    func fetchGenresRequest() {
        checkConnection()
        isLoadingSubject.send(true)
        moviesService.fetchGenres()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else {
                    return
                }
                switch completion {
                case .finished:
                    Logger.info("Genres fetched")
                    self.fetchPopularMovies()
                case .failure(let error):
                    Logger.error(error.localizedDescription)
                    errorSubject.send(error)
                    isLoadingSubject.send(false)
                }
            } receiveValue: { [weak self] genres in
                guard let self = self else {
                    return
                }
                self.genres = genres
                isLoadingSubject.send(false)
            }
            .store(in: &cancellables)
    }
    
    func fetchMovieDetailsRequest(movieId: Int) {
        checkConnection()
        self.movie = nil
        isLoadingSubject.send(true)
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
                    guard let movie = movie else {
                        return
                    }
                    transitionSubject.send(.openDetail(movie: movie))
                case .failure(let error):
                    Logger.error(error.localizedDescription)
                    errorSubject.send(error)
                    isLoadingSubject.send(false)
                }
            } receiveValue: { [weak self] movie in
                guard let self = self else {
                    return
                }
                self.movie = movie
                isLoadingSubject.send(false)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Helper methods
    func checkMoviesList() {
        $movies.combineLatest($cachedMovies)
            .sink { [weak self] movies, cachedMovies in
                guard let self = self else {
                    return
                }
                self.isMoviesEmpty = movies.isEmpty ? true : false
                self.isCachedMoviesEmpty = cachedMovies.isEmpty ? true : false
            }
            .store(in: &cancellables)
    }
    
    func searchMovieLocaly(movieTitle: String) {
        movies = []
        let cachedMovies = moviesCacheService.getCachedMovies()
        self.cachedMovies = cachedMovies.compactMap { $0 }
        
        if !movieTitle.isEmpty {
            self.cachedMovies = self.cachedMovies.filter { $0.title.contains(movieTitle) }
        }
        updateDatasource()
    }
    
    func addPage() {
        if !isRefreshing {
            self.pageCount += 1
        }
    }
    
    func checkCurrentInternetConnectionStatus() {
        NetworkConnectionObserverImpl.shared.networkConnectionObserverPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAvailable in
                guard let self = self else {
                    return
                }
                self.isInternetAvailable = isAvailable
            }
            .store(in: &cancellables)
    }
    
    func checkConnection() {
        guard isInternetAvailable else {
            errorSubject.send(NetworkError.noConnection as NSError)
            return
        }
    }
    
    func checkConnection(completion: @escaping () -> Void) {
        guard isInternetAvailable else {
            errorSubject.send(NetworkError.noConnection as NSError)
            completion()
            return
        }
    }
}
