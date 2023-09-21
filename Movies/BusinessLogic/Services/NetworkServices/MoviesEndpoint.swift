//
//  MoviesEndpoint.swift
//  Movies
//
//  Created by Владислав Баранкевич on 21.09.2023.
//

import Foundation
import Combine

enum MoviesEndpoint: Endpoint {
    case fetchPopularMoviesList(page: Int)
    
    // MARK: - Properties
    var path: String? {
        switch self {
        case .fetchPopularMoviesList:
            return "/3/movie/top_rated"
        }
    }
    
    var httpMethod: HTTPMethods {
        switch self {
        case .fetchPopularMoviesList: return .get
        }
    }
    
    var queries: HTTPQueries {
        switch self {
        case .fetchPopularMoviesList(let page):
            ["page": "\(page)"]
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .fetchPopularMoviesList:
            ["Content-Type": "application/json"]
        }
    }
}
