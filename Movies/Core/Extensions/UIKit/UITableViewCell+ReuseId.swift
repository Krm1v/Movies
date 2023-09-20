//
//  UITableViewCell+ReuseId.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import UIKit

extension UITableViewCell: SelfConfiguringCell {
    static var reuseID: String {
        Self.description()
    }
}
