//
//  GenresResponseModel.swift
//  Movies
//
//  Created by Владислав Баранкевич on 23.09.2023.
//

import Foundation

struct GenresResponseModel: Decodable {
    let genres: [GenresResponse]
}

struct GenresResponse: Decodable {
    let id: Int
    let name: String
}
