//
//  AxisScrollView.swift
//  Movies
//
//  Created by Владислав Баранкевич on 22.09.2023.
//

import UIKit

final class AxisScrollView: UIScrollView {
    // MARK: - Propertirs
    let axis: NSLayoutConstraint.Axis
    let contentView = UIView()

    // MARK: - Init
    init(axis: NSLayoutConstraint.Axis = .vertical) {
        self.axis = axis
        super.init(frame: .zero)
        initialSetup()
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private extension
private extension AxisScrollView {
    func initialSetup() {
        if axis == .vertical {
            addSubview(contentView, constraints: [
                contentView.topAnchor.constraint(equalTo: topAnchor),
                contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
                contentView.widthAnchor.constraint(equalTo: widthAnchor),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        } else {
            addSubview(contentView, constraints: [
                contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
                contentView.heightAnchor.constraint(equalTo: heightAnchor),
                contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
    }
}
