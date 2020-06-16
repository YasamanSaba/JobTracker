//
//  ReminderService.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

enum ReminderServiceError: Error {
    case saveError
}

class ReminderService{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func add(date: Date, message: String, notificationID: String) throws {
        let reminder = Reminder(context: context)
        reminder.date = date
        reminder.desc = message
        reminder.notificationID = notificationID
        do {
            try context.save()
        } catch {
            throw ReminderServiceError.saveError
        }
    }
}
