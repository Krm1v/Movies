//
//  YoutubePlayerView.swift
//  Movies
//
//  Created by Владислав Баранкевич on 23.09.2023.
//

import UIKit
import YouTubeiOSPlayerHelper

final class YoutubePlayerView: BaseView {
    // MARK: - UI Elements
    private(set) var playerView = YTPlayerView()
    
    // MARK: - Init
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
private extension YoutubePlayerView {
    func setupUI() {
        backgroundColor = .black
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(playerView, constraints: [
            playerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            playerView.widthAnchor.constraint(equalTo: self.widthAnchor),
            playerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
        ])
    }
}
