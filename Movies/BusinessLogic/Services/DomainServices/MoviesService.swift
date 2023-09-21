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
    
    func fetchMoviesList(page: Int) -> AnyPublisher<[Movie], Error>
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
    func fetchMoviesList(page: Int) -> AnyPublisher<[Movie], Error> {
        moviesNetworkService.fetchMoviesList(page: page)
            .mapError { $0 as Error }
            .map({ response in
                response.results.map { Movie.init($0) }
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
