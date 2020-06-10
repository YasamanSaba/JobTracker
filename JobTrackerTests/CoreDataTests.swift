//
//  CoreDataTests.swift
//  JobTrackerTests
//
//  Created by Yasaman Farahani Saba on 6/10/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import XCTest
import CoreData
@testable import JobTracker

class CoreDataTests: XCTestCase {

    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let inMemoryStore = InMemoryStore()
        self.context = inMemoryStore.persistentContainer.viewContext
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.context = nil
    }
    
    func test_Save_Company() {
        let company = Company(context: self.context)
        company.title = "Gomora"
        company.isFavorite = true
        XCTAssertNoThrow(try context.save())
        XCTAssertTrue(company.isFavorite)
        XCTAssertNil(company.connecter)
        XCTAssertEqual(company.title, "Gomora")
    }
    
    func test_Save_Fetch_Company() {
        let company = Company(context: self.context)
        company.title = "eGym"
        company.isFavorite = true
        company.connecter = "Rose"
        XCTAssertNoThrow(try context.save())
        let fetchRequest: NSFetchRequest<Company> = Company.fetchRequest()
        var item: [Company] = []
        XCTAssertNoThrow(item = try self.context.fetch(fetchRequest))
        XCTAssertEqual(item.count, 1)
        let storedCompany = item.first
        XCTAssertNotNil(storedCompany)
        XCTAssertEqual(storedCompany!.title, company.title)
        XCTAssertTrue(storedCompany!.isFavorite)
        XCTAssertEqual(storedCompany!.connecter, company.connecter)
    }
    
    func test_Company_ToCity() {
        let country = Country(context: self.context)
        country.name = "Germany"
        country.minSalary = 40000
        let city = City(context: self.context)
        city.name = "Berlin"
        city.country = country
        XCTAssertNoThrow(try context.save())
        let fetchCity: NSFetchRequest<City> = City.fetchRequest()
        var cityItem: [City] = []
        XCTAssertNoThrow(cityItem = try context.fetch(fetchCity))
        XCTAssertEqual(cityItem.count, 1)
        let storedCity = cityItem.first
        XCTAssertNotNil(storedCity)
        XCTAssertEqual(storedCity?.name, city.name)
    }
}
