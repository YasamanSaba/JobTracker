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
    
    func test_add_reminder() {
        let date = Date()
        let message = "just for test"
        let notificationID = UUID().uuidString
        
        XCTAssertNoThrow(try service.add(date: date, message: message, notificationID: notificationID))
    }
}
