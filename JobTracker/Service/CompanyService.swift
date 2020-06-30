//
//  CompanyService.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/30/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import CoreData

class CompanyService: CompanyServiceType {
    
    let context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
     
    func getAll() -> NSFetchedResultsController<Company> {
        let fetchRequest: NSFetchRequest<Company> = Company.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Company.title), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func add(name: String) throws {
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        let predicate = NSPredicate(format: "%K == [c] %@", #keyPath(Company.title),name)
        request.predicate = predicate
        
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                throw CompanyServiceError.alreadyExists
            }
            let company = Company(context: context)
            company.title = name
            company.isFavorite = false
            try context.save()
        } catch {
            throw error
        }
    }
    
}
