//
//  UIImageView+ImageCache.swift
//  Movies
//
//  Created by Владислав Баранкевич on 21.09.2023.
//

import SDWebImage
import UIKit

extension UIImageView {
    func setImage(_ url: URL) {
        self.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
    }
}
