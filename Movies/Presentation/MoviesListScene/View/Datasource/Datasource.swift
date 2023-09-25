//
//  Datasource.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import Foundation

enum MoviesListSceneSections: Int, Hashable {
    case main
}

enum MoviesListSceneItems: Hashable {
    case movie(MoviesListSceneCellModel)
}

struct MoviesListSceneCellModel: Hashable, Identifiable {
    let id = UUID()
    let movieId: Int
    let poster: String
    let movieTitle: String
    let movieReleaseDate: String
    var genre: [String] = []
    let averageRate: String
    
    // MARK: - Init
    init(_ movie: Movie) {
        self.movieId = movie.movieId
        self.poster = movie.poster
        self.movieTitle = movie.title
        self.movieReleaseDate = String(movie.releaseDate.prefix(4))
        self.averageRate = String(movie.averageRating)
    }
}
