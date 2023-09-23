//
//  VideoResponseModel.swift
//  Movies
//
//  Created by Владислав Баранкевич on 23.09.2023.
//

import Foundation

struct VideoResponseModel: Decodable {
    let results: [VideoModel]
}

struct VideoModel: Decodable {
    let id: String
    let key: String
    let name: String
    let site: String
}
