//
//  MoviesNetworkService.swift
//  Movies
//
//  Created by Владислав Баранкевич on 21.09.2023.
//

import Foundation
import Combine

protocol MoviesNetworkService {
    func fetchTopRatedMovies(page: Int) -> AnyPublisher<MovieResponseModel, NetworkError>
    func fetchPopularMovies(page: Int) -> AnyPublisher<MovieResponseModel, NetworkError>
    func searchMovie(title: String) -> AnyPublisher<MovieResponseModel, NetworkError>
    func fetchMovieDetails(movieId: Int) -> AnyPublisher<MovieDetailResponseModel, NetworkError>
    func fetchGenres() -> AnyPublisher<GenresResponseModel, NetworkError>
}

final class MoviesNetworkServiceImpl<NetworkProvider: NetworkServiceProvider> where NetworkProvider.EndpointType == MoviesEndpoint {
    // MARK: - Properties
    private let networkProvider: NetworkProvider
    
    // MARK: - Init
    init(_ networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
}

// MARK: - Extension MoviewNetworkService
extension MoviesNetworkServiceImpl: MoviesNetworkService {
    func fetchTopRatedMovies(page: Int) -> AnyPublisher<MovieResponseModel, NetworkError> {
        networkProvider.execute(endpoint: .fetchTopRatedMovies(page: page), decodeType: MovieResponseModel.self)
    }
    
    func fetchPopularMovies(page: Int) -> AnyPublisher<MovieResponseModel, NetworkError> {
        networkProvider.execute(endpoint: .fetchPopularMovies(page: page), decodeType: MovieResponseModel.self)
    }
    
    func searchMovie(title: String) -> AnyPublisher<MovieResponseModel, NetworkError> {
        networkProvider.execute(endpoint: .searchMovie(title: title), decodeType: MovieResponseModel.self)
    }
    
    func fetchMovieDetails(movieId: Int) -> AnyPublisher<MovieDetailResponseModel, NetworkError> {
        networkProvider.execute(endpoint: .fetchMovieDetails(movieId: movieId), decodeType: MovieDetailResponseModel.self)
    }
    
    func fetchGenres() -> AnyPublisher<GenresResponseModel, NetworkError> {
        networkProvider.execute(endpoint: .fetchGenres, decodeType: GenresResponseModel.self)
    }
}
