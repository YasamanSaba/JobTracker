//
//  ApplyViewModelDelegate.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 7/19/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

protocol ApplyViewModelDelegate: ViewModelDelegate {
    func applyInfo(_ : ApplyViewModel.ApplyInfo)
}
