//
//  MovieDetailResponseModel.swift
//  Movies
//
//  Created by Владислав Баранкевич on 22.09.2023.
//

import Foundation

struct MovieDetailResponseModel: Decodable {
    let posterPath: String
    let title: String
    let releaseDate: String
    let productionCountries: [ProductionCountries]
    let genres: [Genres]
    let overview: String
    let voteAverage: Double
    let videos: VideoResponseModel?
}

extension MovieDetailResponseModel {
    struct ProductionCountries: Decodable {
        let name: String
    }
    
    struct Genres: Decodable {
        let name: String
    }
}
