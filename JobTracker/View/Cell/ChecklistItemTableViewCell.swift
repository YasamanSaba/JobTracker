//
//  ChecklistItemTableViewCell.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/15/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class ChecklistItemTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ChecklistItemTableViewCell.self)

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgCheckmark: UIImageView!

    var isDone: Bool = false {
        didSet {
            if isDone {
                if isDone != oldValue {
                    imgCheckmark.transform = .init(scaleX: 2, y: 2)
                    UIView.animate(withDuration: 1) { [weak self] in
                        self?.imgCheckmark.isHidden = false
                        self?.imgCheckmark.transform = .identity
                    }
                } else {
                    imgCheckmark.isHidden = false
                }
            } else {
                imgCheckmark.isHidden = true
            }
        }
    }
    
    func configure(title:String?, isDone: Bool) {
        lblTitle.text = title
        self.isDone = isDone
    }
    
}
