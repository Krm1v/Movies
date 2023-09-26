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
        selectViewState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarButton()
    }
    
    // MARK: - Deinit
    deinit {
        cancellables.removeAll()
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
                DispatchQueue.main.async {
                    self.title = self.viewModel.sortingParameters.screenTitle
                }
            }
            .store(in: &cancellables)
    }
    
    func selectViewState() {
        viewModel.$isMoviesEmpty.combineLatest(viewModel.$isCachedMoviesEmpty)
            .sink { [weak self] isMoviesEmpty, isCachedMoviesEmpty in
                guard let self = self else {
                    return
                }
                self.contentView.selectViewState(isMoviesEmpty: isMoviesEmpty && isCachedMoviesEmpty)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] actions in
                switch actions {
                case .didReachedBottom:
                    viewModel.tableViewDidReachedBottom()
                    
                case .didSelectItem(let item):
                    switch item {
                    case .movie(let model):
                        viewModel.openDetailScene(with: model.movieId)
                    }
                    
                case .refreshControlDidRefresh(let isRefreshing):
                    viewModel.refreshMovies(
                        isRefreshing: isRefreshing) { [weak self] in
                        guard let self = self else {
                            return
                        }
                            self.contentView.stopRefreshing()
                    }
                    
                case .filterButtonDidTapped:
                    showActionSheet { [weak self] in
                        guard let self = self else {
                            return
                        }
                        viewModel.resetToDefaultValues()
                        viewModel.sortingParameters == .topRated ? viewModel.fetchTopRatedMovies() : viewModel.fetchPopularMovies()
                    }
                case .searchBarTextDidChanged(let text):
                    viewModel.searchMovie(movieTitle: text)
                    
                case .searchBarButtonTapped:
                    contentView.endEditing(true)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Action sheet setup
    func showActionSheet(completion: @escaping () -> Void) {
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
                viewModel.sortingParameters = .topRated
                completion()
            }
        
        let popularAction = UIAlertAction(
            title: Localization.popular,
            style: .default) { [weak self] _ in
                guard let self = self else {
                    return
                }
                viewModel.sortingParameters = .popular
                completion()
            }
        
        let cancelAction = UIAlertAction(
            title: Localization.cancel,
            style: .cancel)
        
        switch viewModel.sortingParameters {
        case .topRated:
            topRatedAction.setValue(
                true,
                forKey: "checked")
            
        case .popular:
            popularAction.setValue(
                true,
                forKey: "checked")
        }
        
        [popularAction, topRatedAction, cancelAction]
            .forEach { action in
                actionSheet.addAction(action)
            }
        present(actionSheet, animated: true)
    }
    
    func setupNavBarButton() {
        contentView.navBarButton.style = .plain
        contentView.navBarButton.image = UIImage(systemName: "list.dash")
        contentView.navBarButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = contentView.navBarButton
    }
}
