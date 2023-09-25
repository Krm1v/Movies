//
//  PosterDetailSceneViewModel.swift
//  Movies
//
//  Created by Владислав Баранкевич on 22.09.2023.
//

import Foundation
import Combine

final class PosterDetailSceneViewModel: BaseViewModel {
    // MARK: - Properties
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<PosterDetailSceneTransitions, Never>()
    private let posterPath: String
    @Published var datasource: PosterDetailModel?
    
    // MARK: - Init
    init(posterPath: String) {
        self.posterPath = posterPath
    }
    
    // MARK: - Overriden methods
    override func onViewDidLoad() {
        updateDatasource()
    }
}

// MARK: - Private extension
private extension PosterDetailSceneViewModel {
    func updateDatasource() {
        datasource = .init(posterPath: posterPath)
    }
}
