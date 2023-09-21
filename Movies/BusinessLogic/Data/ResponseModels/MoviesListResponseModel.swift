//
//  MoviesListResponseModel.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import Foundation

struct MovieResponseModel: Decodable {
    let page: Int
    let results: [MovieResponse]
}

struct MovieResponse: Decodable {
    let id: Int
    let title: String
    let overview: String?
    let voteAverage: Double
    let posterPath: String?
    let releaseDate: String?
    let video: Bool
    let genres: [Genre]?
}

struct Genre: Decodable {
    let id: Int
    let name: String
}
