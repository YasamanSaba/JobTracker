//
//  Reminderable.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

protocol Reminderable: CVarArg {
    func addToReminder(_ value: Reminder)
}

extension Interview: Reminderable{}
extension Task: Reminderable{}
