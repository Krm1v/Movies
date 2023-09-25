//
//  PosterDetailSceneViewController.swift
//  Movies
//
//  Created by Владислав Баранкевич on 22.09.2023.
//

import UIKit
import Combine

final class PosterDetailSceneViewController: BaseViewController<PosterDetailSceneViewModel> {
    // MARK: - Properties
    private let contentView = PosterDetailSceneView()
    
    // MARK: - UIView lifecycle methods
    override func loadView() {
        view = contentView
        contentView.scrollView.delegate = self
    }
    
    override func viewDidLoad() {
        setupBindings()
        super.viewDidLoad()
        updateDatasource()
    }
}

// MARK: - Private extension
private extension PosterDetailSceneViewController {
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
                contentView.configure(model)
            }
            .store(in: &cancellables)
    }
    
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] actions in
                switch actions {
                case .closeButtonDidTapped:
                    dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Extension UIScrollViewDelegate
extension PosterDetailSceneViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        contentView.posterImageView
    }
}
