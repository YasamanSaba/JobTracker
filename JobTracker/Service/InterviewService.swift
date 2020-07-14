//
//  InterviewService.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/28/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

struct InterviewService: InterviewServiceType {
    // MARK: - Properties -
    let context: NSManagedObjectContext!
    // MARK: - Initializer -
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    // MARK: - Functions -
    func fetch(apply: Apply) -> NSFetchedResultsController<Interview> {
        let fetchRequest: NSFetchRequest<Interview> = Interview.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(Interview.apply), apply])
        let sort = NSSortDescriptor(key: #keyPath(Interview.date), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    func delete(interview: Interview) throws {
        context.delete(interview)
        do {
            try context.save()
        } catch {
            throw InterviewServiceError.deleteError
        }
    }
    func getAllRoles() -> [InterviewerRole] {
        InterviewerRole.allCases
    }
    func update(interview: Interview, date: Date?, link: URL?, interviewer: String?, role:InterviewerRole?, desc: String?, tags: [Tag]?) throws {
        if let date = date {
            interview.date = date
        }
        if let link = link {
            interview.link = link
        }
        if let interviewer = interviewer {
            interview.interviewers = interviewer
        }
        if let role = role {
            interview.interviewerRoleEnum = role
        }
        if let desc = desc {
            interview.desc = desc
        }
        if let tags = tags {
            interview.tag = Set(tags) as NSSet
        }
        do {
            try context.save()
        } catch {
            throw InterviewServiceError.updateError
        }
    }
    func save(date: Date, link: URL?, interviewer: String?, role:InterviewerRole, desc: String?, tags: [Tag], for apply: Apply) throws -> Interview {
        let interview = Interview(context: context)
        interview.date = date
        interview.link = link
        interview.interviewers = interviewer
        interview.interviewerRoleEnum = role
        interview.desc = desc
        interview.tag = Set(tags) as NSSet
        apply.addToInterview(interview)
        do {
            try context.save()
            return interview
        } catch {
            throw InterviewServiceError.saveInterviewError
        }
    }
}
