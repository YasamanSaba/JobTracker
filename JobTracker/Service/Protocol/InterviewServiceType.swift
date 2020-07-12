//
//  InterviewServiceType.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/28/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import CoreData

enum InterviewServiceError: Error {
    case fetchError
    case deleteError
}

protocol InterviewServiceType {
    func fetch(apply: Apply) -> NSFetchedResultsController<Interview>
    func delete(interview: Interview) throws
    func getAllRoles() -> [InterviewerRole]
}
