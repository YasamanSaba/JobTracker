//
//  ResumeTableViewCell.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/4/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class ResumeTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ResumeTableViewCell.self)
    
    @IBOutlet private weak var lblVersion: UILabel!
    @IBOutlet private weak var lblNumberOfApplies: UILabel!
    
    func configure(version: String, applyCount: String) {
        lblVersion.text = version
        lblNumberOfApplies.text = applyCount
    }
}
