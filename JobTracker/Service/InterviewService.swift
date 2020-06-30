//
//  InterviewService.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/28/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

struct InterviewService: InterviewServiceType {
    // MARK: - Properties -
    let context: NSManagedObjectContext!
    // MARK: - Initializer -
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    // MARK: - Functions -
    func fetch(apply: Apply) -> NSFetchedResultsController<Interview> {
        let fetchRequest: NSFetchRequest<Interview> = Interview.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(Interview.apply), apply])
        let sort = NSSortDescriptor(key: #keyPath(Interview.date), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    func delete(interview: Interview) throws {
        context.delete(interview)
        do {
            try context.save()
        } catch {
            throw InterviewServiceError.deleteError
        }
    }
}
