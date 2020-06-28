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
    
    func fetchAll() -> NSFetchedResultsController<Country> {
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Country.name), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
}
