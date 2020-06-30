//
//  TaskService.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/28/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import CoreData

struct TaskService: TaskServiceType {
    // MARK: - Properties -
    let context: NSManagedObjectContext!
    // MARK: - Initializer -
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    // MARK: - Functions -
    func fetch(apply: Apply) -> NSFetchedResultsController<Task> {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(Task.apply), apply])
        let sort = NSSortDescriptor(key: #keyPath(Task.date), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    func delete(task: Task) throws {
        context.delete(task)
        do {
            try context.save()
        } catch {
            throw TaskServiceError.deleteError
        }
    }
}
