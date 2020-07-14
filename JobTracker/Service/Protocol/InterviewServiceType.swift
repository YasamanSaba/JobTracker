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
    case updateError
    case saveInterviewError
}

protocol InterviewServiceType {
    func fetch(apply: Apply) -> NSFetchedResultsController<Interview>
    func delete(interview: Interview) throws
    func getAllRoles() -> [InterviewerRole]
    func update(interview: Interview, date: Date?, link: URL?, interviewer: String?, role:InterviewerRole?, desc: String?, tags: [Tag]?) throws
    func save(date: Date, link: URL?, interviewer: String?, role:InterviewerRole, desc: String?, tags: [Tag], for apply: Apply) throws -> Interview
}
