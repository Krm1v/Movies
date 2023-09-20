//
//  UIView+Shadow.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import UIKit

extension UIView {
    func addShadow(
        color: UIColor = .black,
        radius: CGFloat = 4.0,
        offset: CGSize = CGSize(width: 0, height: 2),
        opacity: Float = 0.5
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
    }
}
