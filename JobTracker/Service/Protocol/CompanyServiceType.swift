//
//  CompanyServiceType.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/30/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import CoreData

enum CompanyServiceError: Error {
    case alreadyExists
    case addError
    case setFavoriteError
}

protocol CompanyServiceType {
    func getAll() -> NSFetchedResultsController<Company>
    func add(name: String) throws
    func setIsFavorite(for apply: Apply, _ value: Bool) throws
}
