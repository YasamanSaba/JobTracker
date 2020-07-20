//
//  TaskViewModelDelegate.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/19/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

protocol TaskViewModelDelegate: ViewModelDelegate {
    func deadline(text: String)
    func assignDate(text: String)
    func title(_ : String)
    func link(_ : String)
}
