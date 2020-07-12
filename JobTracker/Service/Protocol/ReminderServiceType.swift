//
//  ReminderServiceType.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import CoreData

enum ReminderServiceError: Error {
    case saveError
    case deleteError
    case fetchError
}

protocol ReminderServiceType {
    func add(date: Date, message: String, notificationID: String) throws -> Reminder
    func delete(reminder: Reminder) throws
    func fetchAll(for reminderable: Reminderable) throws -> NSFetchedResultsController<Reminder>
}
