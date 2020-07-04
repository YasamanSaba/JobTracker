//
//  ResumeService.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/4/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import CoreData

class ResumeService: ResumeServiceType {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getAll() -> NSFetchedResultsController<Resume> {
        let request: NSFetchRequest<Resume> = Resume.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Resume.version), ascending: false)
        request.sortDescriptors = [sort]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }
    
    func add(version: String, url: URL) throws {
        let request:NSFetchRequest<Resume> = Resume.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Resume.version), version)
        request.predicate = predicate
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                throw ResumeServiceError.alreadyExists
            }
        }catch {
            throw error
        }
        let resume = Resume(context: context)
        resume.version = version
        resume.linkToGit = url
        do {
            try context.save()
        } catch {
            throw error
        }
    }
}
