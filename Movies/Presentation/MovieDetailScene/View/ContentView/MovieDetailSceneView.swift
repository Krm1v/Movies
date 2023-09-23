//
//  MovieDetailSceneView.swift
//  Movies
//
//  Created by Владислав Баранкевич on 22.09.2023.
//

import UIKit
import Combine

enum MovieDetailViewActions {
    case imageViewDidTapped
    case youtubeButtonDidTapped
}

final class MovieDetailSceneView: BaseView {
    // MARK: - UI Elements
    private let scrollView = AxisScrollView(axis: .vertical)
    
    private let mainStackView = UIStackView()
    private let titleVStack = UIStackView()
    private let ratingHStack = UIStackView()
    
    private let posterImageView = UIImageView()
    
    private let titleLabel = UILabel()
    private let countryYearLabel = UILabel()
    private let genreLabel = UILabel()
    private let ratingLabel = UILabel()
    private let overviewLabel = UILabel()
    
    private let youtubeButton = UIButton(type: .system)
    private let tapPosterGesture = UITapGestureRecognizer()
    
    // MARK: - Properties
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MovieDetailViewActions, Never>()
    
    // MARK: - init
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
    
    // MARK: - Public methods
    func configure(model: MovieDetailModel) {
        youtubeButton.alpha = model.video != nil ? 1.0 : 0
        titleLabel.text = model.title
        var countries = model.countries
        countries.append(model.year ?? "")
        countryYearLabel.setCommaSeparatedText(from: countries)
        genreLabel.setCommaSeparatedText(from: model.genres ?? [])
        ratingLabel.text = "\(Localization.rating): \(model.rating ?? "")"
        overviewLabel.text = model.overview
        guard let url = model.image else {
            return
        }
        
        posterImageView.setImage(url)
    }
}

// MARK: - Private extension
private extension MovieDetailSceneView {
    func setupUI() {
        backgroundColor = .white
        setupLayout()
        scrollView.delaysContentTouches = false
        
        titleLabel.font = .systemFont(ofSize: 30, weight: .semibold)
        titleLabel.numberOfLines = 0
        
        countryYearLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        countryYearLabel.numberOfLines = 0
        
        genreLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        genreLabel.numberOfLines = 0
        
        overviewLabel.text = "Overview"
        overviewLabel.textAlignment = .justified
        overviewLabel.numberOfLines = 0
        
        posterImageView.image = Assets.placeholder.image
        posterImageView.isUserInteractionEnabled = true
        posterImageView.addGestureRecognizer(tapPosterGesture)
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.clipsToBounds = true
        posterImageView.addShadow()
        
        ratingLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        setupYoutubeButton()
        
    }
    
    func setupLayout() {
        // MARK: - ScrollView
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        
        scrollView.contentSize = contentRect.size
        addSubview(scrollView, withEdgeInsets: .all(.zero))
        
        scrollView.contentView.addSubview(posterImageView, constraints: [
            posterImageView.topAnchor.constraint(equalTo: scrollView.contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: scrollView.contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: scrollView.contentView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.1)
        ])
        
        scrollView.contentView.addSubview(mainStackView, constraints: [
            mainStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentView.bottomAnchor)
        ])
        
        // MARK: - Other UI elements
        setupStackViews()
        
        [titleLabel, countryYearLabel, genreLabel].forEach { label in
            titleVStack.addArrangedSubview(label)
        }
        
        [youtubeButton, ratingLabel].forEach { element in
            ratingHStack.addArrangedSubview(element)
        }
        
        mainStackView.addArrangedSubview(titleVStack)
        mainStackView.addArrangedSubview(ratingHStack)
        mainStackView.addArrangedSubview(overviewLabel)
    }
    
    func setupYoutubeButton() {
        let image =  Assets.youtubeIcon.image.resizedImage(
            size: CGSize(width: 45, height: 45))
        youtubeButton.setImage(
            image?.withRenderingMode(.alwaysOriginal),
            for: .normal)
    }
    
    func setupStackViews() {
        mainStackView.setup(
            axis: .vertical,
            alignment: .fill,
            distribution: .fillProportionally,
            spacing: 8)
        
        titleVStack.setup(
            axis: .vertical,
            alignment: .leading,
            distribution: .equalSpacing,
            spacing: 8)
        
        ratingHStack.setup(
            axis: .horizontal,
            alignment: .center,
            distribution: .equalSpacing,
            spacing: .zero)
    }
    
    func bindActions() {
        youtubeButton.tapPublisher
            .map { MovieDetailViewActions.youtubeButtonDidTapped }
            .subscribe(actionSubject)
            .store(in: &cancellables)
        
        tapPosterGesture.tapPublisher
            .map { _ in MovieDetailViewActions.imageViewDidTapped }
            .subscribe(actionSubject)
            .store(in: &cancellables)
    }
}

#if DEBUG
// MARK: - SwiftUI preview
import SwiftUI

struct FlowProvider: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            let container = AppContainerImpl()
            let vm = MovieDetailViewModel(movieId: 123, moviesService: container.moviesService)
            let viewController = MovieDetailViewController(viewModel: vm)
            return viewController
        }
    }
}
#endif
