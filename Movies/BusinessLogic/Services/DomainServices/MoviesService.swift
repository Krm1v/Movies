//
//  MoviesService.swift
//  Movies
//
//  Created by Владислав Баранкевич on 21.09.2023.
//

import Foundation
import Combine

protocol MoviesService: AnyObject {
    var movies: [Movie] { get set }
    var moviesPublisher: AnyPublisher<[Movie], Error> { get }
    
    func fetchTopRatedMovies(page: Int) -> AnyPublisher<[Movie], Error>
    func fetchPopularMovies(page: Int) -> AnyPublisher<[Movie], Error>
    func searchMovie(title: String) -> AnyPublisher<[Movie], Error>
    func fetchMovieDetails(movieId: Int) -> AnyPublisher<MovieDetail, Error>
    func fetchGenres() -> AnyPublisher<[Genre], Error>
}

final class MoviesServiceImpl {
    // MARK: - Properties
    private(set) lazy var moviesPublisher = moviesSubject.eraseToAnyPublisher()
    private let moviesSubject = CurrentValueSubject<[Movie], Error>([])
    private let moviesNetworkService: MoviesNetworkService
    
    // MARK: - Init
    init(moviesNetworkService: MoviesNetworkService) {
        self.moviesNetworkService = moviesNetworkService
    }
    
    // MARK: - Public methods
    func fetchTopRatedMovies(page: Int) -> AnyPublisher<[Movie], Error> {
        moviesNetworkService.fetchTopRatedMovies(page: page)
            .mapError { $0 as Error }
            .map({ response in
                response.results.map { Movie.init($0) }
            })
        
            .eraseToAnyPublisher()
    }
    
    func fetchPopularMovies(page: Int) -> AnyPublisher<[Movie], Error> {
        moviesNetworkService.fetchPopularMovies(page: page)
            .mapError { $0 as Error }
            .map { response in
                response.results.map { Movie.init($0) }
            }
            .eraseToAnyPublisher()
    }
    
    func searchMovie(title: String) -> AnyPublisher<[Movie], Error> {
        moviesNetworkService.searchMovie(title: title)
            .mapError { $0 as Error }
            .map { response in
                response.results.map { Movie.init($0) }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchMovieDetails(movieId: Int) -> AnyPublisher<MovieDetail, Error> {
        moviesNetworkService.fetchMovieDetails(movieId: movieId)
            .mapError { $0 as Error }
            .map(MovieDetail.init)
            .eraseToAnyPublisher()
    }
    
    func fetchGenres() -> AnyPublisher<[Genre], Error> {
        moviesNetworkService.fetchGenres()
            .mapError { $0 as Error }
            .map({ response in
                response.genres.map { Genre($0) }
            })
            .eraseToAnyPublisher()
    }
}

// MARK: - Extension MoviesService
extension MoviesServiceImpl: MoviesService {
    var movies: [Movie] {
        get { return moviesSubject.value }
        set { moviesSubject.value = newValue }
    }
}
