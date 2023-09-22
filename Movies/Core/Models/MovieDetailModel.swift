//
//  MovieDetailModel.swift
//  Movies
//
//  Created by Владислав Баранкевич on 22.09.2023.
//

import Foundation

struct MovieDetailModel {
    // MARK: - Init
    let image: URL?
    let title: String
    var countries: [String]
    let year: String?
    let genres: [String]?
    let rating: String?
    let overview: String?
    let isVideo: Bool
    
    // MARK: - Init
    init(_ movieDetails: MovieDetail) {
        self.image = PosterBaseUrl.original(path: movieDetails.posterPath ).url
        self.title = movieDetails.title
        self.countries = movieDetails.productionCountries
        let releaseDate = String(movieDetails.releaseDate.prefix(4))
        self.year = releaseDate
        self.genres = movieDetails.genres
        self.rating = String(format: "%.1f", movieDetails.voteAverage)
        self.overview = movieDetails.overview
        self.isVideo = movieDetails.isVideo
    }
}
