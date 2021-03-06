//
//  InterviewTableViewCell.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/15/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class InterviewTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: InterviewTableViewCell.self)

    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(role: String, date: String) {
        self.lblRole.text = role
        self.lblDate.text = date
    }
}
