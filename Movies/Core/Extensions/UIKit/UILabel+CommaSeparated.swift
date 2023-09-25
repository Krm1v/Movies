//
//  UILabel+CommaSeparated.swift
//  Movies
//
//  Created by Владислав Баранкевич on 22.09.2023.
//

import UIKit

extension UILabel {
    func setCommaSeparatedText(from strings: [String]) {
        let commaSeparatedText = strings.joined(separator: ", ")
        self.text = commaSeparatedText
    }
}
