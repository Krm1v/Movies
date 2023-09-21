//
//  Datasource.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import Foundation

enum MoviesListSceneSections: Hashable {
    case main
}

enum MoviesListSceneItems: Hashable {
    case movie(MoviesListSceneCellModel)
}

struct MoviesListSceneCellModel: Hashable {
    let poster: String
    let movieTitle: String
    let movieReleaseDate: String
    let genre: [String]
    let averageRate: String
    
    // MARK: - Init
    init(_ movie: Movie) {
        self.poster = movie.poster
        self.movieTitle = movie.title
        self.movieReleaseDate = String(movie.releaseDate.prefix(4))
        self.genre = movie.genres
        self.averageRate = String(movie.averageRating)
    }
}
