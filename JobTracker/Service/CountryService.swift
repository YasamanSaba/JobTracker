//
//  CountryService.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class CountryService: CountryServiceType {
    
    let context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchAll(withoutworld: Bool) -> NSFetchedResultsController<Country> {
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        if withoutworld {
            let predicate = NSPredicate(format: "%K != %@", #keyPath(Country.name), "World")
            fetchRequest.predicate = predicate
        }
        let sort = NSSortDescriptor(key: #keyPath(Country.name), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func add(name: String, flag: String) throws {
        let request:NSFetchRequest<Country> = Country.fetchRequest()
        let predicate = NSPredicate(format: "%K == [c] %@", #keyPath(Country.name), name)
        request.predicate = predicate
        
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                throw CountryServiceError.alreadyExists
            }
        } catch {
            throw error
        }
        
        let country = Country(context: context)
        country.name = name
        country.flag = flag
        
        do {
            try context.save()
        } catch {
            throw CountryServiceError.addError
        }
    }
    func getWorld() throws -> Country {
        let request: NSFetchRequest<Country> = Country.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Country.name), "World")
        request.predicate = predicate
        do {
            let result = try context.fetch(request)
            return result.first!
        } catch {
            throw error
        }
    }
}
