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
    case companyHasRelation
    case deleteError
}

protocol CompanyServiceType {
    func getAll() -> NSFetchedResultsController<Company>
    func add(name: String, isFavorite: Bool) throws
    func setIsFavorite(for apply: Apply, _ value: Bool) throws
    func delete(company: Company) throws
}
