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
    
}

protocol TagServiceType {
    func fetchAll() -> NSFetchedResultsController<Tag>
}
