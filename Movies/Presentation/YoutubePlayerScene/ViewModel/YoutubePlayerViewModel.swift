//
//  YoutubePlayerViewModel.swift
//  Movies
//
//  Created by Владислав Баранкевич on 23.09.2023.
//

import Foundation
import Combine

final class YoutubePlayerViewModel: BaseViewModel {
    // MARK: - Properties
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<YoutubePlayerSceneTransitions, Never>()
    private(set) var trailerKey: MovieTrailerModel
    
    // MARK: - Init
    init(trailerKey: MovieTrailerModel) {
        self.trailerKey = trailerKey
    }
}
