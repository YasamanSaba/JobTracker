//
//  FlagCell.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/15/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class FlagCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: FlagCell.self)
    @IBOutlet weak var lblFlag: UILabel!
    @IBOutlet weak var lblCountryName: UILabel!
}
