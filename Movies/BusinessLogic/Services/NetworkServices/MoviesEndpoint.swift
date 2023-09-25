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
    case searchMovie(title: String)
    case fetchMovieDetails(movieId: Int)
    case fetchGenres
    
    // MARK: - Properties
    var path: String? {
        switch self {
        case .fetchTopRatedMovies:
            return "/3/movie/top_rated"
        case .fetchPopularMovies:
            return "/3/movie/popular"
        case .searchMovie:
            return "/3/search/movie"
        case .fetchMovieDetails(let movieId):
            return "/3/movie/\(movieId)"
        case .fetchGenres:
            return "/3/genre/movie/list"
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
            return ["page": "\(page)"]
        case .fetchMovieDetails:
            return ["append_to_response": "videos"]
        case .searchMovie(let title):
            return ["query": "\(title)"]
        case .fetchGenres:
            return ["": ""]
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        default: return ["Content-Type": "application/json"]
        }
    }
}
