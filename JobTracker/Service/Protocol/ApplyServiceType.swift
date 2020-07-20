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
    case updateApplyError
}
protocol ApplyServiceType {
    func getAllResumeVersion() -> NSFetchedResultsController<Resume>
    func fetchAll() -> NSFetchedResultsController<Apply>
    func save(apply: Apply, state: Status) throws
    func save(apply: Apply, resume: Resume) throws
    func delete(apply: Apply) throws
    func save(applyItem: ApplyService.ApplyItem) throws
    func add(tags: [Tag], to apply: Apply) throws
    func deleteTags(from apply: Apply) throws
    func delete(tag: Tag, from apply: Apply) throws
    func update(apply: Apply, company: Company?, city: City?, country: Country?, link: URL?, salary: Int32?, state: Status?, resume: Resume?, date: Date?, tags: [Tag]?) throws
    func fetch(apply: Apply) -> NSFetchedResultsController<Apply>
}
