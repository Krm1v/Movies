//
//  ViewModel.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import Foundation
import Combine

final class MoviesListSceneViewModel: BaseViewModel {
    // MARK: - Typealiases
    typealias MoviesSectionModel = SectionModel<MoviesListSceneSections, MoviesListSceneItems>
    
    // MARK: - Properties
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<MoviesListSceneTransitions, Never>()
    
    // MARK: - Published properties
    @Published var sections: [MoviesSectionModel] = []
    
    // MARK: - Overriden methods
    override func onViewWillAppear() {
        updateDatasource()
    }
}

// MARK: - Private extension
private extension MoviesListSceneViewModel {
    func updateDatasource() {
        let mainSection = MoviesSectionModel(
            section: .main,
            items: [
                .movie(.init(poster: "",
                             movieTitle: "La la land",
                             movieReleaseDate: "2018",
                             genre: "Music",
                             averageRate: "10")),
                .movie(.init(
                    poster: "",
                    movieTitle: "Interstellar",
                    movieReleaseDate: "2014",
                    genre: "Fantastic",
                    averageRate: "9"))
            ])
        sections = [mainSection]
    }
}
