//
//  MoviesEndpoint.swift
//  Movies
//
//  Created by Владислав Баранкевич on 21.09.2023.
//

import Foundation
import Combine

enum MoviesEndpoint: Endpoint {
    case fetchTopRatedMovies(page: Int)
    case fetchPopularMovies(page: Int)
    case getMovieGenres(id: Int)
    case searchMovie(title: String)
    case fetchMovieDetails(movieId: Int)
    
    // MARK: - Properties
    var path: String? {
        switch self {
        case .fetchTopRatedMovies:
            return "/3/movie/top_rated"
        case .getMovieGenres(let id):
            return "/3/movie/\(id)"
        case .fetchPopularMovies:
            return "/3/movie/popular"
        case .searchMovie:
            return "/3/search/movie"
        case .fetchMovieDetails(let movieId):
            return "/3/movie/\(movieId)"
        }
    }
    
    var httpMethod: HTTPMethods {
        switch self {
        default: return .get
        }
    }
    
    var queries: HTTPQueries {
        switch self {
        case .fetchTopRatedMovies(let page), .fetchPopularMovies(let page):
            ["page": "\(page)"]
        case .getMovieGenres, .fetchMovieDetails:
            [:]
        case .searchMovie(let title):
            ["query": "\(title)"]
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        default: ["Content-Type": "application/json"]
        }
    }
}
