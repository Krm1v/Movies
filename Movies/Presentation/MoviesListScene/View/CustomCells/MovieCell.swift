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
    private let titleHStack = UIStackView()
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
    
    // MARK: - Public methods
    func configure(_ model: MoviesListSceneCellModel) {
        titleLabel.text = "\(model.movieTitle), \(model.movieReleaseDate)"
        genresLabel.text = model.genre
        ratingLabel.text = model.averageRate
    }
}

// MARK: - Private extension
private extension MovieCell {
    func setupUI() {
        setupLayout()
        setupPosterImageView()
        titleLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        titleLabel.textColor = .darkGray
        [genresLabel, ratingLabel].forEach { label in
            label.font = .systemFont(ofSize: 17, weight: .semibold)
            label.textColor = .lightGray
        }
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
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 16)
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
    
    func setupPosterImageView() {
        posterImageView.rounded(12)
        posterImageView.layer.shadowColor = UIColor.black.cgColor
        posterImageView.layer.shadowRadius = 3.0
        posterImageView.layer.shadowOpacity = 1.0
        posterImageView.layer.shadowOffset = CGSize(width: 4, height: 4)
        posterImageView.layer.masksToBounds = false
        posterImageView.backgroundColor = .systemGray6
    }
}

// MARK: - Constants
fileprivate enum Constants {
    static let defaultEdgeInset: CGFloat = 8
}
