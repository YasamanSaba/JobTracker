//
//  ReminderService.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class ReminderService: ReminderServiceType{
    let context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func add(date: Date, message: String, notificationID: String) throws -> Reminder {
        let reminder = Reminder(context: context)
        reminder.date = date
        reminder.desc = message
        reminder.notificationID = notificationID
        do {
            try context.save()
            return reminder
        } catch {
            throw ReminderServiceError.saveError
        }
    }
}
