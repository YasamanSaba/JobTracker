//
//  ApplyService.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/20/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

struct ApplyService: ApplyServiceType {
    let context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    func getAllState() -> [Status] {
        Status.allCases
    }
    func getAllResumeVersion() -> NSFetchedResultsController<Resume> {
        let fetchRequest: NSFetchRequest<Resume> = Resume.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Resume.version), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    func fetchAll() -> NSFetchedResultsController<Apply> {
        let fetchRequest: NSFetchRequest<Apply> = Apply.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Apply.date), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    func save(apply: Apply, state: Status) throws {
        apply.statusEnum = state
        do {
            try context.save()
        } catch {
            throw ApplyServiceError.saveError
        }
    }
}
