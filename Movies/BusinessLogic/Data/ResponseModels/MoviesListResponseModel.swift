//
//  MoviesListResponseModel.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import Foundation

struct Empty: Decodable {
    let page: Int
    let results: [MovieResponseModel]
    let totalPages: Int
    let totalResults: Int
}

struct MovieResponseModel: Decodable {
    let adult: Bool
    let genreIDS: [Int]
    let id: Int
    let originalTitle: String
    let overview: String
    let posterPath: String
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
}
