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
    
    // MARK: - Init
    init(moviesService: MoviesService) {
        self.moviesService = moviesService
    }
    
    // MARK: - Overriden methods
    override func onViewDidLoad() {
        fetchMovies()
    }
    
    override func onViewWillAppear() {
        updateDatasource()
    }
    
    // MARK: - Public methods
    func fetchMovies() {
        isLoadingSubject.send(true)
        moviesService.fetchMoviesList(page: pageCount)
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
                    self.pageCount += 1
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
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private extension
private extension MoviesListSceneViewModel {
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
}

enum PosterBaseUrl {
    case original(path: String)
    case w500(path: String)
    
    var url: URL? {
        switch self {
        case .original(let path):
            return URL(string: "https://image.tmdb.org/t/p/original" + path)
        case .w500(let path):
            return URL(string: "https://image.tmdb.org/t/p/w500" + path)
        }
    }
}
