//
//  TagServiceType.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import CoreData

enum TagServiceError: Error {
    case fetchError
    case existingTag
    case addError
    case deleteError
    case tagHasOtherRelation
}

protocol TagServiceType {
    func fetchAll() -> NSFetchedResultsController<Tag>
    func add(tag: String) throws
    func delete(tag: Tag) throws
    func fetchAll(for interview: Interview) -> NSFetchedResultsController<Tag>
}
