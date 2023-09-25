//
//  Movie.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import Foundation

final class Movie {
    // MARK: - Properties
    let movieId: Int
    let poster: String
    let title: String
    let releaseDate: String
    var genres: [Int]
    let overview: String
    let averageRating: Double
    
    // MARK: - Init
    init(
        movieId: Int,
        poster: String,
        title: String,
        releaseDate: String,
        genres: [Int],
        overview: String,
        averageRating: Double
    ) {
        self.movieId = movieId
        self.poster = poster
        self.title = title
        self.releaseDate = releaseDate
        self.genres = genres
        self.overview = overview
        self.averageRating = averageRating
    }
    
    init(_ response: MovieResponse) {
        self.movieId = response.id
        self.poster = response.posterPath ?? ""
        self.title = response.title
        self.releaseDate = response.releaseDate ?? ""
        self.overview = response.overview ?? ""
        self.averageRating = response.voteAverage
        self.genres = response.genreIds
    }
}
