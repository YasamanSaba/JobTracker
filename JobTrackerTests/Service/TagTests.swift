//
//  TagTests.swift
//  JobTrackerTests
//
//  Created by Sam Javadizadeh on 6/20/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import XCTest
import CoreData
@testable import JobTracker

class TagTests: XCTestCase {
    
    var service: TagServiceType!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        let inMemoryStore = InMemoryStore()
        context = inMemoryStore.persistentContainer.viewContext
        service = TagService(context: context)
    }

    override func tearDownWithError() throws {
        context = nil
        service = nil
    }

    func test_fetchAll() {
        let t1 = Tag(context: context)
        t1.title = "Tag1"
        let t2 = Tag(context: context)
        t2.title = "Tag2"
        let t3 = Tag(context: context)
        t3.title = "Tag3"
        
        XCTAssertNoThrow(try context.save())
        
        let resultController = service.fetchAll()
        XCTAssertNoThrow(try resultController.performFetch())
        XCTAssertEqual(resultController.fetchedObjects?.count, 3)
    }
    
    func test_Add() {
        XCTAssertNoThrow(try service.add(tag: "MyTag"))
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        var result: [Tag] = []
        XCTAssertNoThrow(result = try context.fetch(request))
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.title, "MyTag")
    }
    
    func test_Delete() {
        let t1 = Tag(context: context)
        t1.title = "Tag1"
        XCTAssertNoThrow(try context.save())
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        var result: [Tag] = []
        XCTAssertNoThrow(result = try context.fetch(request))
        XCTAssertEqual(result.count, 1)
        XCTAssertNoThrow(try service.delete(tag: t1))
        XCTAssertNoThrow(result = try context.fetch(request))
        XCTAssertEqual(result.count, 0)
    }
}
