//
//  Genre.swift
//  Movies
//
//  Created by Владислав Баранкевич on 23.09.2023.
//

import Foundation

final class Genre {
    // MARK: - Properties
    let id: Int
    let name: String
    
    // MARK: - Init
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init(_ response: GenresResponse) {
        self.id = response.id
        self.name = response.name
    }
}
