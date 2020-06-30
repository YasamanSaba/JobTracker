//
//  TagTableViewCell.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/20/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class TagTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: TagTableViewCell.self)
    
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
