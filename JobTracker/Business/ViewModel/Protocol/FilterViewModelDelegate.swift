//
//  FilterViewModelDelegate.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 7/20/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

protocol FilterViewModelDelegate: ViewModelDelegate {
    func fromDate(text: String)
    func toDate(text: String)
}
