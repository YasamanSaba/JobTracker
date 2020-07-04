//
//  CityService.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/28/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

struct CityService: CityServiceType {
    
    let context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchAll(in country: Country) -> NSFetchedResultsController<City> {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(City.country), country)
        fetchRequest.predicate = predicate
        let sort = NSSortDescriptor(key: #keyPath(City.name), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func add(name: String, to country: Country) throws {
        let request:NSFetchRequest<City> = City.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@", #keyPath(City.name), name, #keyPath(City.country), country)
        request.predicate = predicate
        
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                throw CityServiceError.alreadyExists
            }
        } catch {
            throw error
        }
        
        let city = City(context: context)
        city.name = name
        country.addToCity(city)
        
        do {
            try context.save()
        } catch {
            throw CityServiceError.addError
        }
    }
}
