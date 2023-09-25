//
//  SectionModel.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import Foundation

struct SectionModel<Section: Hashable, Item: Hashable> {
    let section: Section
    var items: [Item]
}
