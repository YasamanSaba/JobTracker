//
//  CountryService.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import CoreData

struct CountryService: CountryServiceType {
    
    let context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchAll() throws -> [Country] {
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        do {
            let countries = try context.fetch(fetchRequest)
            return countries
        } catch {
            throw CountryServiceError.fetchError
        }
    }
}
