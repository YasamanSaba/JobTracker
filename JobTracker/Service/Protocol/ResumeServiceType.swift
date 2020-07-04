//
//  ResumeServiceType.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/4/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import CoreData

enum ResumeServiceError: Error {
    case fetchError
    case alreadyExists
}

protocol ResumeServiceType {
    func getAll() -> NSFetchedResultsController<Resume>
    func add(version: String, url: URL) throws
}
