//
//  CityTests.swift
//  JobTrackerTests
//
//  Created by Sam Javadizadeh on 6/28/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import XCTest
import CoreData
@testable import JobTracker

class CityTests: XCTestCase {
    
    var service: CityServiceType!
    var context: NSManagedObjectContext!

    override func setUpWithError() throws {
        let inMemoryStore = InMemoryStore()
        context = inMemoryStore.persistentContainer.viewContext
        service = CityService(context: context)
    }

    override func tearDownWithError() throws {
        context = nil
        service = nil
    }

    func test_fetchAll_By_Country() {
        let germany = Country(context: context)
        germany.name = "Germany"
        germany.flag = "🇩🇪"
        
        let berlin = City(context: context)
        berlin.name = "Berlin"
        
        let munich = City(context: context)
        munich.name = "Munich"
        
        germany.addToCity(berlin)
        germany.addToCity(munich)
        
        XCTAssertNoThrow(try context.save())
        let controller = service.fetchAll(in: germany)
        XCTAssertNoThrow(try controller.performFetch())
        XCTAssertNotNil(controller.fetchedObjects)
        XCTAssertEqual(controller.fetchedObjects!.count, 2)
        
    }
    
    func test_fetchAll_By_Different_Country() {
        let germany = Country(context: context)
        germany.name = "Germany"
        germany.flag = "🇩🇪"
        
        let uk = Country(context: context)
        uk.name = "United Kingdom"
        uk.flag = "🇬🇧"
        
        let berlin = City(context: context)
        berlin.name = "Berlin"
        
        let munich = City(context: context)
        munich.name = "Munich"
        
        germany.addToCity(berlin)
        germany.addToCity(munich)
        
        XCTAssertNoThrow(try context.save())
        let controller = service.fetchAll(in: uk)
        XCTAssertNoThrow(try controller.performFetch())
        XCTAssertNotNil(controller.fetchedObjects)
        XCTAssertEqual(controller.fetchedObjects!.count, 0)
        
    }
}
