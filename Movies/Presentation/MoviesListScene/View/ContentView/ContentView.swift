//
//  ContentView.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import UIKit
import Combine
import CombineCocoa

enum MovieSceneActions {
    case didReachedBottom
    case didSelectItem(MoviesListSceneItems)
    case refreshControlDidRefresh(Bool)
    case filterButtonDidTapped
    case searchBarTextDidChanged(String)
    case searchBarButtonTapped
}

final class MoviesSceneView: BaseView {
    typealias MoviesSceneDatasource = UITableViewDiffableDataSource<MoviesListSceneSections, MoviesListSceneItems>
    typealias MoviesSceneSnapshot = NSDiffableDataSourceSnapshot<MoviesListSceneSections, MoviesListSceneItems>
    
    // MARK: - UI Elements
    private let searchBar = UISearchBar()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let refreshControl = UIRefreshControl()
    private let navBarButton = UIBarButtonItem()
    
    // MARK: - Properties
    private var datasource: MoviesSceneDatasource?
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MovieSceneActions, Never>()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindActions()
        setupUI()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        bindActions()
        setupUI()
        setupTableView()
    }
    
    // MARK: - Public methods
    func setupSnapshot(sections: [SectionModel<MoviesListSceneSections, MoviesListSceneItems>]) {
        var snapshot = MoviesSceneSnapshot()
        sections.forEach { section in
            snapshot.appendSections([section.section])
            snapshot.appendItems(section.items, toSection: section.section)
        }
        datasource?.apply(snapshot, animatingDifferences: false)
    }
    
    func setupNavBarButton(for controller: UIViewController) {
        navBarButton.style = .plain
        navBarButton.image = UIImage(systemName: "list.dash")
        navBarButton.tintColor = .black
        controller.navigationItem.rightBarButtonItem = navBarButton
    }
    
    func stopRefreshing() {
        refreshControl.endRefreshing()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.rowHeight = self.frame.width * 0.8
    }
}

// MARK: - Private extension
private extension MoviesSceneView {
    func setupUI() {
        backgroundColor = .white
        searchBar.placeholder = Localization.search
        searchBar.returnKeyType = .done
        searchBar.enablesReturnKeyAutomatically = false
        setupLayout()
        tableView.refreshControl = refreshControl
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
    }
    
    func setupLayout() {
        addSubview(searchBar, constraints: [
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        addSubview(tableView, constraints: [
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupTableView() {
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseID)
        setupDatasource()
    }
    
    func setupDatasource() {
        datasource = .init(tableView: tableView, cellProvider: { [weak self] (tableView, indexPath, item) -> UITableViewCell? in
            guard let self = self else {
                return UITableViewCell()
            }
            switch item {
            case .movie(let model):
                let cell = tableView.configureCell(
                    cellType: MovieCell.self,
                    indexPath: indexPath)
                cell.configure(model)
                
                return cell
            }
        })
    }
    
    func bindActions() {
        tableView.reachedBottomPublisher()
            .map { MovieSceneActions.didReachedBottom }
            .subscribe(actionSubject)
            .store(in: &cancellables)
        
        tableView.didSelectRowPublisher
            .compactMap { [unowned self] indexPath in
                datasource?.itemIdentifier(for: indexPath)
            }
            .map { MovieSceneActions.didSelectItem($0) }
            .subscribe(actionSubject)
            .store(in: &cancellables)
        
        refreshControl.isRefreshingPublisher
            .map { MovieSceneActions.refreshControlDidRefresh($0) }
            .subscribe(actionSubject)
            .store(in: &cancellables)
        
        navBarButton.tapPublisher
            .map { MovieSceneActions.filterButtonDidTapped }
            .subscribe(actionSubject)
            .store(in: &cancellables)
        
        searchBar.textDidChangePublisher
            .map { MovieSceneActions.searchBarTextDidChanged($0) }
            .subscribe(actionSubject)
            .store(in: &cancellables)
        
        searchBar.searchButtonClickedPublisher
            .map { MovieSceneActions.searchBarButtonTapped }
            .subscribe(actionSubject)
            .store(in: &cancellables)
    }
}
