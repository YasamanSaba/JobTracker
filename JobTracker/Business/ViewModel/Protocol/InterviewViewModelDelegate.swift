//
//  InterviewViewModelDelegate.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/19/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

protocol InterviewViewModelDelegate: ViewModelDelegate {
    func role(text: String)
    func date(text: String)
    func link(text: String)
    func interviewer(text: String)
    func desc(text: String)
}
