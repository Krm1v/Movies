//
//  ViewController.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import UIKit

final class MoviesListSceneViewController: BaseViewController<MoviesListSceneViewModel> {
    // MARK: - Properties
    private let contentView = MoviesSceneView()
    
    // MARK: - UIView lifecycle methods
    override func loadView() {
        view = contentView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSnapshot()
        title = Localization.home
    }
}

// MARK: - Private extension
private extension MoviesListSceneViewController {
    func updateSnapshot() {
        viewModel.$sections
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] sections in
                self.contentView.setupSnapshot(sections: sections)
            }
            .store(in: &cancellables)
    }
}
