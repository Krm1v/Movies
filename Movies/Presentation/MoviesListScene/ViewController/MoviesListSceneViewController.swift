//
//  ViewController.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import UIKit

fileprivate enum SortingParameters {
    case topRated
    case popular
}

final class MoviesListSceneViewController: BaseViewController<MoviesListSceneViewModel> {
    // MARK: - Properties
    private let contentView = MoviesSceneView()
    private var sortingParameters: SortingParameters = .topRated
    
    // MARK: - UIView lifecycle methods
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        setupBindings()
        super.viewDidLoad()
        updateSnapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = Localization.popular
        contentView.setupNavBarButton(for: self)
    }
}

// MARK: - Private extension
private extension MoviesListSceneViewController {
    // MARK: - Diffable datasource snapshot update method
    func updateSnapshot() {
        viewModel.$sections
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] sections in
                self.contentView.setupSnapshot(sections: sections)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] actions in
                switch actions {
                case .didReachedBottom:
                    sortingParameters == .topRated ? viewModel.fetchTopRatedMovies() : viewModel.fetchPopularMovies()
                    
                case .didSelectItem(let item):
                    switch item {
                    case .movie(let model):
                        viewModel.openDetailScene(with: model.movieId)
                    }
                    
                case .refreshControlDidRefresh(let isRefreshing):
                    if isRefreshing {
                        viewModel.resetToDefaultValues()
                        sortingParameters == .topRated ? viewModel.fetchTopRatedMovies() : viewModel.fetchPopularMovies()
                        if !viewModel.isRefreshing {
                            contentView.stopRefreshing()
                        }
                    } else {
                        viewModel.isRefreshing = isRefreshing
                    }
                    
                case .filterButtonDidTapped:
                    showActionSheet { [weak self] in
                        guard let self = self else {
                            return
                        }
                        viewModel.resetToDefaultValues()
                        sortingParameters == .topRated ? viewModel.fetchTopRatedMovies() : viewModel.fetchPopularMovies()
                    }
                case .searchBarTextDidChanged(let text):
                    if !text.isEmpty {
                        viewModel.searchMovie(movieTitle: text)
                    } else {
                        viewModel.resetToDefaultValues()
                        sortingParameters == .topRated ? viewModel.fetchTopRatedMovies() : viewModel.fetchPopularMovies()
                    }
                    
                case .searchBarButtonTapped:
                    contentView.endEditing(true)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Action sheet setup
    func showActionSheet(completion: @escaping () -> (Void)) {
        let actionSheet = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet)
        
        let topRatedAction = UIAlertAction(
            title: Localization.topRated,
            style: .default) { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.sortingParameters = .topRated
                completion()
            }
        
        let popularAction = UIAlertAction(
            title: Localization.popular,
            style: .default) { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.sortingParameters = .popular
                completion()
            }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel)
        
        switch sortingParameters {
        case .topRated:
            topRatedAction.setValue(
                true,
                forKey: "checked")
            
        case .popular:
            popularAction.setValue(
                true,
                forKey: "checked")
        }
        
        [topRatedAction, popularAction, cancelAction]
            .forEach { action in
                actionSheet.addAction(action)
            }
        present(actionSheet, animated: true)
    }
}
