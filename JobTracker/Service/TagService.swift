//
//  TagService.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import CoreData

struct TagService: TagServiceType {
    
    let context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchAll() -> NSFetchedResultsController<Tag> {
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Tag.title), ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }
    
    func add(tag: String) throws {
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Tag.title), tag)
        request.predicate = predicate
        
        do {
            let result = try context.fetch(request)
            if result.count != 0 {
                throw TagServiceError.existingTag
            }
            let newTag = Tag(context: context)
            newTag.title = tag
            try context.save()
        } catch TagServiceError.existingTag {
            throw TagServiceError.existingTag
        } catch {
            throw TagServiceError.addError
        }
    }
    
    func delete(tag: Tag) throws {
        context.delete(tag)
        do {
            try context.save()
        } catch {
            throw TagServiceError.deleteError
        }
    }
    func fetchAll(for interview: Interview) -> NSFetchedResultsController<Tag> {
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Tag.interview),interview)
        request.predicate = predicate
        let sort = NSSortDescriptor(key: #keyPath(Tag.title), ascending: true)
        request.sortDescriptors = [sort]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }
}
