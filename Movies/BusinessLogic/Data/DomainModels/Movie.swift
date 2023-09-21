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
    let genres: [String]
    let overview: String
    let averageRating: Double
    let isTrailerAvailable: Bool
    
    // MARK: - Init
    init(
        id: Int,
        poster: String,
        title: String,
        releaseDate: String,
        genres: [String],
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
        self.genres = response.genres?.compactMap { $0.name } ?? []
    }
}
