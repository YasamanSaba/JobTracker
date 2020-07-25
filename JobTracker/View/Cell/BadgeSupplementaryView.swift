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
    
    func configure(count: Int) {
        self.addSubview(label)
        NSLayoutConstraint.activate([
            self.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            self.centerXAnchor.constraint(equalTo: label.centerXAnchor),
        ])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .caption2), size: 11)
        label.textColor = .white
        label.text = String(count)
        backgroundColor = .systemRed
        let radius = bounds.width / 2.0
        layer.cornerRadius = radius
    }
    
    override func prepareForReuse() {
        self.superview?.bringSubviewToFront(self)
    }
}
