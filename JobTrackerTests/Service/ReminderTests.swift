//
//  ReminderTests.swift
//  JobTrackerTests
//
//  Created by Sam Javadizadeh on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import XCTest
import CoreData
@testable import JobTracker

class ReminderTests: XCTestCase {
    
    var service: ReminderServiceType!
    var context: NSManagedObjectContext!
    var interview: Interview!
    var apply: Apply!

    override func setUpWithError() throws {
        let inMemoryStore = InMemoryStore()
        context = inMemoryStore.persistentContainer.viewContext
        service = ReminderService(context: context)
        interview = Interview(context: self.context)
        interview.date = Date()
        interview.interviewerRoleEnum = .ceo
        let city = City(context: self.context)
        city.name = "Barcelona"
        let country = Country(context: self.context)
        country.name = "Spain"
        country.minSalary = 40000
        country.addToCity(city)
        let company = Company(context: self.context)
        company.title = "eFly"
        company.isFavorite = true
        let apply = Apply(context: self.context)
        apply.date = Date()
        apply.statusEnum = .challenge
        apply.jobLink = URL(string: "google")
        city.addToApply(apply)
        let resume = Resume(context: self.context)
        resume.version = "1.4"
        resume.addToApply(apply)
        company.addToApply(apply)
        apply.addToInterview(interview)
    }

    override func tearDownWithError() throws {
        service = nil
        interview = nil
        apply = nil
    }
    
    func test_Add_Reminder_NoThrow() {
        let date = Date()
        let message = "just for test"
        let notificationID = UUID().uuidString
        
        XCTAssertNoThrow(try service.add(date: date, message: message, notificationID: notificationID, for: interview))
    }
    
    func test_Add_Reminder_Insertion_In_Coredata() {
        let date = Date()
        let message = "just for test"
        let notificationID = UUID().uuidString
        
        var storedReminder: Reminder? = nil
        XCTAssertNoThrow(storedReminder = try service.add(date: date, message: message, notificationID: notificationID, for: interview))
        XCTAssertNotNil(storedReminder)
        XCTAssertEqual(storedReminder?.date, date)
        XCTAssertEqual(storedReminder?.desc, message)
        XCTAssertEqual(storedReminder?.notificationID, notificationID)
    }
    
    func test_Delete_Reminder() {
        let date = Date()
        let message = "just for test"
        let notificationID = UUID().uuidString
        
        var storedReminder: Reminder? = nil
        XCTAssertNoThrow(storedReminder = try service.add(date: date, message: message, notificationID: notificationID, for: interview))
        
        let request: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        var result: [Reminder] = []
        XCTAssertNoThrow(result = try context.fetch(request))
        XCTAssertEqual(result.count, 1)
        
        XCTAssertNoThrow(try service.delete(reminder: storedReminder!))
        
        XCTAssertNoThrow(result = try context.fetch(request))
        XCTAssertEqual(result.count, 0)
    }
}
