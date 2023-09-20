//
//  ErrorResponseModel.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import Foundation

struct APIErrorResponseModel: Decodable {
    let code:    Int
    let message: String
}
