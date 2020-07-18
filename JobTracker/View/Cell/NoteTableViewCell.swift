//
//  NoteTableViewCell.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/18/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: NoteTableViewCell.self)
    
    @IBOutlet weak var lblTitle: UILabel!
    
    func configure(title: String) {
        lblTitle.text = title
    }
}
