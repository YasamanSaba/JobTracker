//
//  ReminderTests.swift
//  JobTrackerTests
//
//  Created by Sam Javadizadeh on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import XCTest
@testable import JobTracker

class ReminderTests: XCTestCase {
    
    var service: ReminderServiceType!

    override func setUpWithError() throws {
        let inMemoryStore = InMemoryStore()
        service = ReminderService(context: inMemoryStore.persistentContainer.viewContext)
    }

    override func tearDownWithError() throws {
        service = nil
    }
    
    func test_Add_Reminder_NoThrow() {
        let date = Date()
        let message = "just for test"
        let notificationID = UUID().uuidString
        
        XCTAssertNoThrow(try service.add(date: date, message: message, notificationID: notificationID))
    }
    
    func test_Add_Reminder_Insertion_In_Coredata() {
        let date = Date()
        let message = "just for test"
        let notificationID = UUID().uuidString
        
        var storedReminder: Reminder? = nil
        XCTAssertNoThrow(storedReminder = try service.add(date: date, message: message, notificationID: notificationID))
        XCTAssertNotNil(storedReminder)
        XCTAssertEqual(storedReminder?.date, date)
        XCTAssertEqual(storedReminder?.desc, message)
        XCTAssertEqual(storedReminder?.notificationID, notificationID)
    }
}
