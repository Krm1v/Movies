//
//  MovieCell.swift
//  Movies
//
//  Created by Владислав Баранкевич on 20.09.2023.
//

import UIKit
import Combine

final class MovieCell: UITableViewCell {
    // MARK: - UI Elements
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let footerHStack = UIStackView()
    private let genresLabel = UILabel()
    private let ratingLabel = UILabel()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Overriden methods
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        genresLabel.text = nil
        ratingLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.layer.shadowPath = UIBezierPath(rect: posterImageView.layer.bounds).cgPath
    }
    
    // MARK: - Public methods
    func configure(_ model: MoviesListSceneCellModel) {
        guard let url = PosterBaseUrl.original(path: model.poster).url else {
            return
        }
        posterImageView.setImage(url)
        titleLabel.setCommaSeparatedText(from: [model.movieTitle, model.movieReleaseDate])
        genresLabel.setCommaSeparatedText(from: model.genre)
        ratingLabel.text = model.averageRate
    }
}

// MARK: - Private extension
private extension MovieCell {
    func setupUI() {
        setupLayout()
        posterImageView.clipsToBounds = true
        posterImageView.addShadow()
        posterImageView.contentMode = .scaleToFill
        titleLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        titleLabel.numberOfLines = 0
        
        [titleLabel, ratingLabel, genresLabel].forEach { label in
            label.textColor = .white
            label.backgroundColor = .black.withAlphaComponent(0.5)
            label.rounded(7)
        }
        
        titleLabel.minimumScaleFactor = 0.5
        [genresLabel, ratingLabel].forEach { label in
            label.font = .systemFont(ofSize: 17, weight: .semibold)
            label.textColor = .white
        }
        
        genresLabel.numberOfLines = 0
        genresLabel.minimumScaleFactor = 0.8
        selectionStyle = .none
    }
    
    func setupLayout() {
        addSubview(posterImageView, constraints: [
            posterImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.defaultEdgeInset),
            posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.defaultEdgeInset),
            posterImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.defaultEdgeInset),
            posterImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.defaultEdgeInset)
        ])
        
        addSubview(titleLabel, constraints: [
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: posterImageView.trailingAnchor, constant: -16)
        ])
        
        addSubview(footerHStack, constraints: [
            footerHStack.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 16),
            footerHStack.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -16),
            footerHStack.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -30)
        ])
        
        footerHStack.setup(
            axis: .horizontal,
            alignment: .fill,
            distribution: .equalSpacing,
            spacing: .zero)
        
        [genresLabel, ratingLabel].forEach { label in
            footerHStack.addArrangedSubview(label)
        }
    }
}

// MARK: - Constants
fileprivate enum Constants {
    static let defaultEdgeInset: CGFloat = 8
}
