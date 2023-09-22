//
//  MovieDetail.swift
//  Movies
//
//  Created by Владислав Баранкевич on 22.09.2023.
//

import Foundation

final class MovieDetail: Decodable {
    // MARK: - Properties
    let posterPath: String?
    let title: String
    let releaseDate: String?
    var productionCountries: [String]
    let genres: [String]?
    let overview: String?
    let voteAverage: Double
    let isVideo: Bool
    
    // MARK: - Init
    init(
        posterPath: String?,
        title: String,
        releaseDate: String?,
        productionCountries: [String],
        genres: [String]?,
        overview: String?,
        voteAverage: Double,
        isVideo: Bool
    ) {
        self.posterPath = posterPath
        self.title = title
        self.releaseDate = releaseDate
        self.productionCountries = productionCountries
        self.genres = genres
        self.overview = overview
        self.voteAverage = voteAverage
        self.isVideo = isVideo
    }
    
    init(_ response: MovieDetailResponseModel) {
        self.posterPath = response.posterPath
        self.title = response.title
        self.releaseDate = response.releaseDate
        self.productionCountries = response.productionCountries.compactMap({ country in
            country.name
        })
        if let responseGenres = response.genres {
            self.genres = responseGenres.compactMap({ genreResponse in
                genreResponse.name
            })
        } else {
            self.genres = []
        }
        self.overview = response.overview
        self.voteAverage = response.voteAverage
        self.isVideo = response.video
    }
}
