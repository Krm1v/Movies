//
//  PosterBaseURL.swift
//  Movies
//
//  Created by Владислав Баранкевич on 21.09.2023.
//

import Foundation

enum PosterBaseUrl {
    case original(path: String)
    case w500(path: String)
    
    var url: URL? {
        switch self {
        case .original(let path):
            return URL(string: "https://image.tmdb.org/t/p/original" + path)
        case .w500(let path):
            return URL(string: "https://image.tmdb.org/t/p/w500" + path)
        }
    }
}
