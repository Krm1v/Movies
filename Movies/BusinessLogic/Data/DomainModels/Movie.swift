//
//  Movie.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import Foundation

final class Movie: Decodable {
    // MARK: - Properties
    let poster: String
    let title: String
    let releaseDate: String
    let releaseCountry: String
    let genre: String
    let description: String
    let averageRating: String
    let isTrailerAvailable: Bool
    
    // MARK: - Init
    init(
        poster: String,
        title: String,
        releaseYear: String,
        releaseCountry: String,
        genre: String,
        description: String,
        averageRating: String,
        isTrailerAvailable: Bool
    ) {
        self.poster = poster
        self.title = title
        self.releaseDate = releaseYear
        self.releaseCountry = releaseCountry
        self.genre = genre
        self.description = description
        self.averageRating = averageRating
        self.isTrailerAvailable = isTrailerAvailable
    }
}
