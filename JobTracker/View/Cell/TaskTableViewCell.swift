//
//  TaskTableViewCell.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/15/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: TaskTableViewCell.self)
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDeadline: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(title: String, deadLine: String) {
        self.lblTitle.text = title
        self.lblDeadline.text = deadLine
    }
}
