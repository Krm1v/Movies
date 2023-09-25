//
//  MovieDetail.swift
//  Movies
//
//  Created by Владислав Баранкевич on 22.09.2023.
//

import Foundation

final class MovieDetail {
    // MARK: - Properties
    let id: Int
    let posterPath: String
    let title: String
    let releaseDate: String
    var productionCountries: [String]
    let genres: [String]
    let overview: String
    let voteAverage: Double
    var video: String?
    
    // MARK: - Init
    init(
        id: Int,
        posterPath: String,
        title: String,
        releaseDate: String,
        productionCountries: [String],
        genres: [String],
        overview: String,
        voteAverage: Double,
        video: String?
    ) {
        self.id = id
        self.posterPath = posterPath
        self.title = title
        self.releaseDate = releaseDate
        self.productionCountries = productionCountries
        self.genres = genres
        self.overview = overview
        self.voteAverage = voteAverage
        self.video = video
    }
    
    init(_ response: MovieDetailResponseModel) {
        self.id = response.id
        self.posterPath = response.posterPath
        self.title = response.title
        self.releaseDate = response.releaseDate
        self.productionCountries = response.productionCountries.compactMap({ country in
            country.name
        })
        self.genres = response.genres.compactMap({ genreResponse in
            genreResponse.name
        })
        self.overview = response.overview
        self.voteAverage = response.voteAverage
        if let videoResults = response.videos?.results {
            _ = videoResults.map { self.video = $0.key }
        }
    }
}
