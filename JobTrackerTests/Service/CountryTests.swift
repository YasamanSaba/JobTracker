//
//  CountryTests.swift
//  JobTrackerTests
//
//  Created by Sam Javadizadeh on 6/28/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import XCTest
import CoreData
@testable import JobTracker

class CountryTests: XCTestCase {

    var service: CountryServiceType!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        let inMemoryStore = InMemoryStore()
        context = inMemoryStore.persistentContainer.viewContext
        service = CountryService(context: context)
    }

    override func tearDownWithError() throws {
        context = nil
        service = nil
    }

    func test_fetchAll() {
        let germany = Country(context: context)
        germany.name = "Germany"
        germany.flag = "🇩🇪"
        
        let uk = Country(context: context)
        uk.name = "United Kingdom"
        uk.flag = "🇬🇧"
        
        XCTAssertNoThrow(try context.save())
        let controller = service.fetchAll(withoutworld: false)
        XCTAssertNoThrow(try controller.performFetch())
        XCTAssertNotNil(controller.fetchedObjects)
        XCTAssertEqual(controller.fetchedObjects!.count, 2)
    }
    
}
