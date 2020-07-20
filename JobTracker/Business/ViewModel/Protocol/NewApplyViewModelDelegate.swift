//
//  NewApplyViewModelDelegate.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 7/19/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

protocol NewApplyViewModelDelegate: ViewModelDelegate {
    func country(text: String)
    func city(text: String)
    func date(text: String)
    func company(text: String)
    func resume(text: String)
    func state(text: String)
    func link(text: String)
    func salary(text: String)
}
