//
//  CompanyTableViewCell.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/30/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: CompanyTableViewCell.self)

    @IBOutlet private weak var lblCompanyName: UILabel!
    @IBOutlet private weak var lblNumberOfApply: UILabel!
    @IBOutlet private weak var imgHeart: UIImageView!

    func configure(name: String, numberOfApplies: Int, isFavorite: Bool) {
        lblCompanyName.text = name
        lblNumberOfApply.text = String(numberOfApplies)
        if isFavorite {
            imgHeart.image = UIImage(systemName: "heart.fill")
        } else {
            imgHeart.image = nil
        }
    }
}
