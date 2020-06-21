//
//  ReminderServiceType.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

enum ReminderServiceError: Error {
    case saveError
    case deleteError
}

protocol ReminderServiceType {
    func add(date: Date, message: String, notificationID: String) throws -> Reminder
    func delete(reminder: Reminder) throws
}
