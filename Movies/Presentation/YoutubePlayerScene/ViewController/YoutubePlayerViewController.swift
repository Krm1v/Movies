//
//  YoutubePlayerViewController.swift
//  Movies
//
//  Created by Владислав Баранкевич on 23.09.2023.
//

import UIKit
import YouTubeiOSPlayerHelper

final class YoutubePlayerViewController: BaseViewController<YoutubePlayerViewModel> {
    // MARK: - Properties
    private let contentView = YoutubePlayerView()
    
    // MARK: - UIView lifecycle methods
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.playerView.delegate = self
        loadTrailer()
    }
}

// MARK: - Private extension
private extension YoutubePlayerViewController {
    func loadTrailer() {
        contentView.playerView.load(withVideoId: viewModel.trailerKey.key)
    }
}

// MARK: - Extension YTPlayerViewDelegate
extension YoutubePlayerViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}
