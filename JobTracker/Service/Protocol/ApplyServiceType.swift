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
    case saveApplyStateError
    case saveResumeVersionError
    case saveApplyError
    case deleteError
}
protocol ApplyServiceType {
    func getAllResumeVersion() -> NSFetchedResultsController<Resume>
    func fetchAll() -> NSFetchedResultsController<Apply>
    func save(apply: Apply, state: Status) throws
    func save(apply: Apply, resume: Resume) throws
    func delete(apply: Apply) throws
    func save(applyItem: ApplyService.ApplyItem) throws
}
