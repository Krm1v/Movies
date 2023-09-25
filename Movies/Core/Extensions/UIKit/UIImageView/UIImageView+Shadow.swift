//
//  UIImageView+Shadow.swift
//  Movies
//
//  Created by Владислав Баранкевич on 23.09.2023.
//

import UIKit

extension UIView {
    func addShadow(
        color: UIColor = .black,
        radius: CGFloat = 3.0,
        opacity: Float = 1.0,
        offset: CGSize = .init(width: 4, height: 4)
    ) {
        self.clipsToBounds = true
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.masksToBounds = false
    }
}
