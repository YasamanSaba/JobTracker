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
    
    func delete(reminder: Reminder) throws {
        context.delete(reminder)
        do {
            try context.save()
            return
        } catch {
            throw ReminderServiceError.deleteError
        }
    }
    
    func fetchAll(for reminderable: Reminderable) throws -> NSFetchedResultsController<Reminder> {
        let request: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        var key: String?
        switch reminderable {
        case is Interview:
            key = #keyPath(Reminder.interview)
        case is Task:
            key = #keyPath(Reminder.task)
        default:
            key = nil
        }
        if key == nil { throw ReminderServiceError.fetchError}
        let predicate = NSPredicate(format: " %K == %@ ", key!, reminderable)
        request.predicate = predicate
        let sort = NSSortDescriptor(key: #keyPath(Reminder.date), ascending: true)
        request.sortDescriptors = [sort]
        let controller = NSFetchedResultsController<Reminder>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }
}
