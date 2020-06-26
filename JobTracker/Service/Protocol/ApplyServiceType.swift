//
//  ApplyServiceType.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/20/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import CoreData

enum ApplyServiceError: Error {
    case fetchError
}
protocol ApplyServiceType {
    func getAllState() -> [String] 
    func fetchAll() -> NSFetchedResultsController<Apply>
}
