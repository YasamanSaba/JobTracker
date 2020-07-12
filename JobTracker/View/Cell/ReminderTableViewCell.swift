//
//  ReminderTableViewCell.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/15/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ReminderTableViewCell.self)

    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    func configure(message: String, date: String) {
        lblMessage.text = message
        lblDateTime.text = date
    }

}
