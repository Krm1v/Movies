//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Владислав Баранкевич on 22.09.2023.
//

import Foundation

final class MovieDetailViewController: BaseViewController<MovieDetailViewModel> {
    // MARK: - Properties
    private let contentView = MovieDetailSceneView()
    
    // MARK: - UIView lifecycle methods
    override func loadView() {
        view = contentView
    }
}
