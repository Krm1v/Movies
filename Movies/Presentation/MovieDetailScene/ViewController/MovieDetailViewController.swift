//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Владислав Баранкевич on 22.09.2023.
//

import UIKit

final class MovieDetailViewController: BaseViewController<MovieDetailViewModel> {
    // MARK: - Properties
    private let contentView = MovieDetailSceneView()
    
    // MARK: - UIView lifecycle methods
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        setupBindings()
        super.viewDidLoad()
        updateDatasource()
    }
}

// MARK: - Private extension
private extension MovieDetailViewController {
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] actions in
                switch actions {
                case .youtubeButtonDidTapped:
                    viewModel.openYoutubePlayerScene()
                case .imageViewDidTapped:
                    viewModel.openPosterDetailScene()
                }
            }
            .store(in: &cancellables)
    }
    
    func updateDatasource() {
        viewModel.$datasource
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard
                    let self = self,
                    let model = model
                else {
                    return
                }
                contentView.configure(model: model)
                title = model.title
            }
            .store(in: &cancellables)
    }
}
