//
//  ChecklistServiceType.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/14/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import CoreData

enum ChecklistServiceError: Error {
    case addError
    case deleteError
    case saveError
}

protocol ChecklistServiceType {
    func fetchAll(for apply: Apply) -> NSFetchedResultsController<CheckListItem>
    func add(title: String, for apply: Apply) throws
    func delete(item: CheckListItem) throws
    func set(isDone: Bool, for item: CheckListItem) throws
}
