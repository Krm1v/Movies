//
//  Movie.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import Foundation

final class Movie: Decodable {
    // MARK: - Properties
    let id: Int
    let poster: String
    let title: String
    let releaseDate: String
    var genres: [Genre]
    let overview: String
    let averageRating: Double
    let isTrailerAvailable: Bool
    
    // MARK: - Init
    init(
        id: Int,
        poster: String,
        title: String,
        releaseDate: String,
        genres: [Genre],
        overview: String,
        averageRating: Double,
        isTrailerAvailable: Bool
    ) {
        self.id = id
        self.poster = poster
        self.title = title
        self.releaseDate = releaseDate
        self.genres = genres
        self.overview = overview
        self.averageRating = averageRating
        self.isTrailerAvailable = isTrailerAvailable
    }
    
    init(_ response: MovieResponse) {
        self.id = response.id
        self.poster = response.posterPath ?? ""
        self.title = response.title
        self.releaseDate = response.releaseDate ?? ""
        self.overview = response.overview ?? ""
        self.averageRating = response.voteAverage
        self.isTrailerAvailable = response.video
        if let responseGenres = response.genres {
            self.genres = responseGenres.map({ genreResponse in
                Genre(genreResponse)
            })
        } else {
            self.genres = []
        }
    }
}

final class Genre: Decodable {
    // MARK: - Properties
    let id: Int
    let name: String
    
    // MARK: - Init
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init(_ response: GenreResponse) {
        self.id = response.id
        self.name = response.name
    }
}
