//
//  PosterDetailSceneView.swift
//  Movies
//
//  Created by Владислав Баранкевич on 22.09.2023.
//

import UIKit
import Combine

enum PosterDetailSceneActions {
    case closeButtonDidTapped
}

final class PosterDetailSceneView: BaseView {
    // MARK: - UI Elements
    private(set) var scrollView = UIScrollView()
    private(set) var posterImageView = UIImageView()
    private let closeButton = UIButton(type: .system)
    
    // MARK: - Properties
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<PosterDetailSceneActions, Never>()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindActions()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        bindActions()
        setupUI()
    }
    
    // MARK: - Overriden methods
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = self.bounds
        posterImageView.frame = scrollView.bounds
    }
    
    // MARK: - Public methods
    func configure(_ model: PosterDetailModel) {
        guard let url = PosterBaseUrl.original(path: model.posterPath).url else {
            return
        }
        posterImageView.setImage(url)
    }
}

// MARK: - Private extension
private extension PosterDetailSceneView {
    // MARK: - Setup UI methods
    func setupUI() {
        backgroundColor = .white
        setupLayout()
        setupScrollView()
        posterImageView.contentMode = .scaleAspectFit
        setupCloseButton()
    }
    
    func setupLayout() {
        addSubview(scrollView, withEdgeInsets: .all(.zero))
        scrollView.addSubview(posterImageView)
        addSubview(closeButton, constraints: [
            closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupScrollView() {
        scrollView.zoomScale = 1.0
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delaysContentTouches = false
    }
    
    func setupCloseButton() {
        closeButton.setTitle(Localization.close, for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        closeButton.rounded(12)
    }
    
    // MARK: - Actions
    func bindActions() {
        closeButton.tapPublisher
            .map { PosterDetailSceneActions.closeButtonDidTapped }
            .subscribe(actionSubject)
            .store(in: &cancellables)
    }
}

#if DEBUG
// MARK: - SwiftUI preview
import SwiftUI

struct PosterFlowProvider: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            let path = "/lyQBXzOQSuE59IsHyhrp0qIiPAz.jpg"
            let vm = PosterDetailSceneViewModel(posterPath: path)
            let viewController = PosterDetailSceneViewController(viewModel: vm)
            return viewController
        }
    }
}
#endif
