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
        setupBindings()
        super.viewDidLoad()
        updateSnapshot()
        title = Localization.popularMovies
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
    
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] actions in
                switch actions {
                case .didReachedBottom:
                    viewModel.fetchMovies()
                case .didSelectItem(let item):
                    debugPrint(item)
                case .refreshControlDidRefresh(let didRefresh):
                    debugPrint(didRefresh)
                }
            }
            .store(in: &cancellables)
    }
}
