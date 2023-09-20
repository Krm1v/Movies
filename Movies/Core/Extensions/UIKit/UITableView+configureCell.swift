//
//  UITableView+configureCell.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import UIKit

protocol SelfConfiguringCell: AnyObject {
    static var reuseID: String { get }
}

extension UITableView {
    func configureCell<T: SelfConfiguringCell>(
        cellType: T.Type,
        indexPath: IndexPath
    ) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseID,
                                             for: indexPath) as? T else {
            assert(false, "Error \(cellType)")
        }
        return cell
    }
}
