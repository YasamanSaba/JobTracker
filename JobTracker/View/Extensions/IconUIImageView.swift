//
//  IconUIImageView.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 7/25/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class IconUIImageView: UIImageView {
    override func layoutSubviews() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
}
