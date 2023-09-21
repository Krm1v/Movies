//
//  MoviesNetworkService.swift
//  Movies
//
//  Created by Владислав Баранкевич on 21.09.2023.
//

import Foundation
import Combine

protocol MoviesNetworkService {
    func fetchMoviesList(page: Int) -> AnyPublisher<MovieResponseModel, NetworkError>
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
    func fetchMoviesList(page: Int) -> AnyPublisher<MovieResponseModel, NetworkError> {
        networkProvider.execute(endpoint: .fetchPopularMoviesList(page: page), decodeType: MovieResponseModel.self)
    }
}
