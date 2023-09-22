//
//  MovieDetailSceneView.swift
//  Movies
//
//  Created by Владислав Баранкевич on 22.09.2023.
//

import Foundation

final class MovieDetailSceneView: BaseView {
    // MARK: - Properties
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: - Private extension
private extension MovieDetailSceneView {
    func setupUI() {
        backgroundColor = .green
    }
}
