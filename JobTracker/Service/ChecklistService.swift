//
//  ChecklistService.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/14/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import CoreData

class ChecklistService: ChecklistServiceType {
    let context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchAll(for apply: Apply) -> NSFetchedResultsController<CheckListItem> {
        let request: NSFetchRequest<CheckListItem> = CheckListItem.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(CheckListItem.apply), apply)
        request.predicate = predicate
        let sort = NSSortDescriptor(key: #keyPath(CheckListItem.title), ascending: true)
        request.sortDescriptors = [sort]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }
    
    func add(title: String, for apply: Apply) throws {
        let item = CheckListItem(context: context)
        item.title = title
        item.isDone = false
        apply.addToCheckListItem(item)
        do {
            try context.save()
        } catch {
            throw ChecklistServiceError.addError
        }
    }
    
    func delete(item: CheckListItem) throws {
        context.delete(item)
        do {
            try context.save()
        } catch {
            throw ChecklistServiceError.deleteError
        }
    }
    
    func set(isDone: Bool, for item: CheckListItem) throws {
        item.isDone = isDone
        do {
            try context.save()
        } catch {
            throw ChecklistServiceError.saveError
        }
    }
}
