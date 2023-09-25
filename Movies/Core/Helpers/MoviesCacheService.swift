//
//  MoviesCahceService.swift
//  Movies
//
//  Created by Владислав Баранкевич on 24.09.2023.
//

import Foundation

protocol MoviesCacheService: AnyObject {
    func cacheMovies(movies: [Movie])
    func clearMoviesCache()
    func getCachedMovies() -> [Movie?]
}

final class MoviesCacheServiceImpl: MoviesCacheService {
    // MARK: - Properties
    private let cache = NSCache<NSString, Movie>()
    private var ids: [String] = []
    
    // MARK: - Public methods
    func cacheMovies(movies: [Movie]) {
        for movie in movies {
            cache.setObject(movie, forKey: String(movie.movieId) as NSString)
            ids.append(String(movie.movieId))
        }
    }
    
    func clearMoviesCache() {
        cache.removeAllObjects()
    }
    
    func getCachedMovies() -> [Movie?] {
        var cachedMovies: [Movie?] = []
        for id in ids {
            let object = cache.object(forKey: id as NSString)
            cachedMovies.append(object)
        }
        return cachedMovies
    }
}
