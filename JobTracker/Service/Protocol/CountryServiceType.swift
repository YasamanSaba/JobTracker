//
//  fwfwefwfr.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import CoreData

enum CountryServiceError: Error {
    case fetchError
    case addError
    case alreadyExists
}

protocol CountryServiceType {
    func fetchAll(withoutworld: Bool) -> NSFetchedResultsController<Country>
    func add(name: String, flag: String) throws
    func getWorld() throws -> Country
}
