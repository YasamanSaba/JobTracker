//
//  BadgeSupplementaryView.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/22/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

final class BadgeSupplementaryView: UICollectionReusableView {
    static let reuseIdentifier = String(describing: BadgeSupplementaryView.self)
    
    
    var label: UILabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .caption2), size: 11)
        label.textColor = .white
        backgroundColor = .systemRed
        let radius = bounds.width / 2.0
        layer.cornerRadius = radius
        NSLayoutConstraint.activate([
            self.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            self.centerXAnchor.constraint(equalTo: label.centerXAnchor),
        ])
    }
}
