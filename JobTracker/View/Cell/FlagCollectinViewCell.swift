//
//  FlagCell.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/15/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class FlagCollectinViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: FlagCollectinViewCell.self)
    @IBOutlet weak var lblFlag: UILabel!
    @IBOutlet weak var lblCountryName: UILabel!
}
