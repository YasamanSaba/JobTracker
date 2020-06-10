//
//  AppliesTableViewCell.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/10/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class AppliesTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var lblCountryFlag: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblApplyDate: UILabel!
    @IBOutlet weak var lblNumberOfInterviews: UILabel!
    @IBOutlet weak var lblNumberOfTasks: UILabel!
    @IBOutlet weak var lblCheckListStatus: UILabel!
    @IBOutlet weak var lblApplyStatus: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
