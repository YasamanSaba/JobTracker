//
//  CityServiceType.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/28/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import CoreData

enum CityServiceError: Error {
    case fetchError
    case addError
    case alreadyExists
    case cityHasOtherRelation
    case deleteError
}

protocol CityServiceType {
    func fetchAll() -> NSFetchedResultsController<City>
    func fetchAll(in country: Country) -> NSFetchedResultsController<City>
    func add(name: String, to country: Country) throws
    func delete(city: City) throws
}
