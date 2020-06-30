//
//  TaskServiceType.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/28/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import CoreData

enum TaskServiceError: Error {
    case fetchError
    case deleteError
}

protocol TaskServiceType {
    func fetch(apply: Apply) -> NSFetchedResultsController<Task>
    func delete(task: Task) throws
}
