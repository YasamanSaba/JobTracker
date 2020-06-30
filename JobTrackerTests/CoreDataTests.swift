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
    
    func test_Company() {
        let company = Company(context: self.context)
        company.title = "Fox"
        company.isFavorite = true
        XCTAssertNoThrow(try context.save())
        XCTAssertTrue(company.isFavorite)
        XCTAssertNil(company.connecter)
        XCTAssertEqual(company.title, "Fox")
    }
    func test_Country() {
        let country = Country(context: self.context)
        country.name = "Iran"
        country.minSalary = 2386478
        XCTAssertNoThrow(try self.context.save())
        let countryFetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        var countryItems: [Country] = []
        XCTAssertNoThrow(countryItems = try self.context.fetch(countryFetchRequest))
        XCTAssertNotNil(countryItems)
        XCTAssertEqual(countryItems.count, 1)
        XCTAssertEqual(countryItems.first!.name, country.name)
    }
    func test_City() {
        let city = City(context: self.context)
        city.name = "Berlin"
        let country = Country(context: self.context)
        country.name = "Germany"
        country.minSalary = 87346576
        country.addToCity(city)
        XCTAssertNoThrow(try self.context.save())
        let cityFetchRequest: NSFetchRequest<City> = City.fetchRequest()
        var cityItems: [City] = []
        XCTAssertNoThrow(cityItems = try self.context.fetch(cityFetchRequest))
        XCTAssertNotNil(cityItems)
        XCTAssertEqual(cityItems.count, 1)
        let storedCity = cityItems.first
        XCTAssertNotNil(storedCity)
        XCTAssertEqual(storedCity!.country?.name, country.name)
    }
    func test_Apply() {
        let city = City(context: self.context)
        city.name = "Munich"
        let country = Country(context: self.context)
        country.name = "Germany"
        country.minSalary = 70000
        country.addToCity(city)
        let company = Company(context: self.context)
        company.title = "Koft"
        company.isFavorite = false
        let resume = Resume(context: self.context)
        resume.version = "2.3"
        let apply = Apply(context: self.context)
        apply.date = Date()
        apply.statusEnum = .ceo
        apply.salaryExpectation = 54000
        apply.jobLink = URL(string: "https://www.google.com/?client=safari")
        city.addToApply(apply)
        resume.addToApply(apply)
        company.addToApply(apply)
        XCTAssertNoThrow(try self.context.save())
        let fetchRequest: NSFetchRequest<Apply> = Apply.fetchRequest()
        var applyItem: [Apply] = []
        XCTAssertNoThrow(applyItem = try context.fetch(fetchRequest))
        XCTAssertEqual(applyItem.first!.status, apply.status)
        XCTAssertEqual(applyItem.first!.salaryExpectation, apply.salaryExpectation)
    }
    func test_Resume() {
        let resume = Resume(context: self.context)
        resume.version = "1.2"
        resume.linkToGit = URL(string: "https://www.google.com")
        XCTAssertNoThrow(try self.context.save())
        let fetchRequest: NSFetchRequest<Resume> = Resume.fetchRequest()
        var storedResume: [Resume] = []
        XCTAssertNoThrow(storedResume = try self.context.fetch(fetchRequest))
        let resumeItem = storedResume.first
        XCTAssertEqual(resumeItem!.version, resume.version)
        XCTAssertEqual(resumeItem!.linkToGit, resume.linkToGit)
    }
    func test_Tag() {
        let tag = Tag(context: self.context)
        tag.title = "Core Data"
        XCTAssertNoThrow(try self.context.save())
    }
    func test_Interview() {
        let interview = Interview(context: self.context)
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
        XCTAssertNoThrow(try self.context.save())
        let fetchInterviewRequest: NSFetchRequest<Interview> = Interview.fetchRequest()
        var interviewItem: [Interview] = []
        XCTAssertNoThrow(interviewItem = try self.context.fetch(fetchInterviewRequest))
        let interviewStored = interviewItem.first
        XCTAssertNotNil(interviewStored)
        XCTAssertEqual(interviewStored!.date, interview.date)
        XCTAssertEqual(interviewStored!.interviewerRole, interview.interviewerRole)
    }
    func test_Task() {
        let task = Task(context: self.context)
        task.date = Date()
        task.isDone = false
        task.deadline = Date()
        task.title = "Teeest"
        let city = City(context: self.context)
        city.name = "Barcelona"
        let country = Country(context: self.context)
        country.name = "Spain"
        country.minSalary = 48000
        country.addToCity(city)
        let company = Company(context: self.context)
        company.title = "eee"
        company.isFavorite = false
        let apply = Apply(context: self.context)
        apply.date = Date()
        apply.statusEnum = .hr
        apply.jobLink = URL(string: "test")
        city.addToApply(apply)
        let resume = Resume(context: self.context)
        resume.version = "1.5"
        resume.addToApply(apply)
        company.addToApply(apply)
        apply.addToTask(task)
        XCTAssertNoThrow(try context.save())
        let taskFetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        var taskItem: [Task] = []
        XCTAssertNotNil(taskItem = try context.fetch(taskFetchRequest))
        let storedTask = taskItem.first
        XCTAssertNotNil(storedTask)
        XCTAssertEqual(storedTask!.isDone, task.isDone)
        XCTAssertEqual(storedTask!.title, task.title)
    }
    func test_Reminder() {
        let reminder = Reminder(context: self.context)
        reminder.date = Date()
        reminder.notificationID = "1.2.3.4cjlghksdg"
        reminder.desc = "Please test me"
        XCTAssertNoThrow(try self.context.save())
        let reminderFetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        var reminderItems: [Reminder] = []
        XCTAssertNoThrow(reminderItems = try self.context.fetch(reminderFetchRequest))
        XCTAssertEqual(reminderItems.count, 1)
        let storedReminder = reminderItems.first
        XCTAssertNotNil(storedReminder)
        XCTAssertEqual(storedReminder!.desc, reminder.desc)
        XCTAssertEqual(storedReminder!.notificationID, reminder.notificationID)
    }
    func test_Note() {
        let note = Note(context: self.context)
        note.title = "Sentence 1"
        note.body = "djshfjkagsdfjhgkalkgjsdfkgdfgshgasfkghafkjg"
        XCTAssertNoThrow(try self.context.save())
        let noteFetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        var noteItems: [Note] = []
        XCTAssertNoThrow(noteItems = try self.context.fetch(noteFetchRequest))
        XCTAssertNotNil(noteItems)
        let storedNote = noteItems.first
        XCTAssertNotNil(storedNote)
        XCTAssertEqual(storedNote!.title, note.title)
        XCTAssertEqual(storedNote!.body, note.body)
    }
    func test_CheckListItem() {
        let checkList = CheckListItem(context: self.context)
        checkList.isDone = false
        checkList.title = "hgajsdfjhgadjhg"
        let city = City(context: self.context)
        city.name = "Munich"
        let country = Country(context: self.context)
        country.name = "Germany"
        country.minSalary = 38000
        country.addToCity(city)
        let company = Company(context: self.context)
        company.title = "OLDB"
        company.isFavorite = false
        let resume = Resume(context: self.context)
        resume.version = "2.3"
        let apply = Apply(context: self.context)
        apply.date = Date()
        apply.statusEnum = .inSite
        apply.salaryExpectation = 54000
        apply.jobLink = URL(string: "https://www.google.com/?client=safari")
        company.addToApply(apply)
        resume.addToApply(apply)
        apply.addToCheckListItem(checkList)
        city.addToApply(apply)
        XCTAssertNoThrow(try self.context.save())
        let checkListFetchRequest: NSFetchRequest<CheckListItem> = CheckListItem.fetchRequest()
        var checkListItems: [CheckListItem] = []
        XCTAssertNoThrow(checkListItems = try self.context.fetch(checkListFetchRequest))
        XCTAssertNotNil(checkListItems)
        XCTAssertEqual(checkListItems.count, 1)
        let storedCheckList = checkListItems.first
        XCTAssertNotNil(storedCheckList)
        XCTAssertEqual(storedCheckList!.apply?.date, apply.date)
        XCTAssertEqual(storedCheckList!.apply?.resume, apply.resume)
        XCTAssertEqual(storedCheckList!.apply?.jobLink, apply.jobLink)
    }
    func test_Save_Fetch_Company() {
        let country = Country(context: self.context)
        country.name = "Germany"
        country.minSalary = 40000
        let city = City(context: self.context)
        city.name = "Berlin"
        city.country = country
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
    func test_AddReminder_OnInterview() {
        let reminder = Reminder(context: self.context)
        reminder.date = Date()
        reminder.desc = "This is test"
        reminder.notificationID = "47864357183548"
        let city = City(context: self.context)
        city.name = "Munich"
        let country = Country(context: self.context)
        country.name = "Germany"
        country.minSalary = 70000
        country.addToCity(city)
        let company = Company(context: self.context)
        company.title = "OLDB"
        company.isFavorite = false
        let resume = Resume(context: self.context)
        resume.version = "2.3"
        let apply = Apply(context: self.context)
        apply.date = Date()
        apply.statusEnum = .rejected
        apply.salaryExpectation = 54000
        apply.jobLink = URL(string: "https://www.google.com/?client=safari")
        company.addToApply(apply)
        resume.addToApply(apply)
        city.addToApply(apply)
        let interview = Interview(context: self.context)
        interview.date = Date()
        interview.interviewerRoleEnum = .hr
        interview.interviewers = "Jackson"
        interview.addToReminder(reminder)
        apply.addToInterview(interview)
        XCTAssertNoThrow(try self.context.save())
        let reminderFetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        var reminderItems: [Reminder] = []
        XCTAssertNoThrow(reminderItems = try self.context.fetch(reminderFetchRequest))
        XCTAssertEqual(reminderItems.count, 1)
        let storedReminder = reminderItems.first
        XCTAssertNotNil(storedReminder)
        XCTAssertEqual(storedReminder!.interview?.interviewers, interview.interviewers)
        XCTAssertEqual(storedReminder!.interview?.interviewerRole, interview.interviewerRole)
    }
    func test_AddReminder_OnTask() {
        let reminder = Reminder(context: self.context)
        reminder.date = Date()
        reminder.desc = "This is for test"
        reminder.notificationID = "23780237496638456"
        let task = Task(context: self.context)
        task.date = Date()
        task.isDone = false
        task.deadline = Date()
        task.title = "Teeest"
        let city = City(context: self.context)
        city.name = "Barcelona"
        let country = Country(context: self.context)
        country.name = "Spain"
        country.minSalary = 48000
        country.addToCity(city)
        let company = Company(context: self.context)
        company.title = "eee"
        company.isFavorite = false
        let apply = Apply(context: self.context)
        apply.date = Date()
        apply.statusEnum = .inSite
        apply.jobLink = URL(string: "test")
        let resume = Resume(context: self.context)
        resume.version = "1.5"
        resume.addToApply(apply)
        company.addToApply(apply)
        apply.addToTask(task)
        task.addToReminder(reminder)
        city.addToApply(apply)
        XCTAssertNoThrow(try self.context.save())
        let reminderFetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        var reminderItems: [Reminder] = []
        XCTAssertNoThrow(reminderItems = try self.context.fetch(reminderFetchRequest))
        XCTAssertNotNil(reminderItems)
        XCTAssertEqual(reminderItems.count, 1)
        let storedReminder = reminderItems.first
        XCTAssertNotNil(storedReminder)
        XCTAssertEqual(storedReminder!.task?.isDone, task.isDone)
        XCTAssertEqual(storedReminder!.task?.title, task.title)
        XCTAssertEqual(storedReminder!.task?.date, task.date)
    }
    func test_ReachApply_ByReminder_WithInterview() {
        let reminder = Reminder(context: self.context)
        reminder.date = Date()
        reminder.desc = "This is tesssst"
        reminder.notificationID = "10797435672565"
        let city = City(context: self.context)
        city.name = "Munich"
        let country = Country(context: self.context)
        country.name = "Germany"
        country.minSalary = 75000
        country.addToCity(city)
        let company = Company(context: self.context)
        company.title = "Forrest"
        company.isFavorite = false
        let resume = Resume(context: self.context)
        resume.version = "2.8"
        let apply = Apply(context: self.context)
        apply.date = Date()
        apply.statusEnum = .challenge
        apply.salaryExpectation = 74000
        apply.jobLink = URL(string: "https://www.google.com")
        city.addToApply(apply)
        company.addToApply(apply)
        resume.addToApply(apply)
        let interview = Interview(context: self.context)
        interview.date = Date()
        interview.interviewerRoleEnum = .recruiter
        interview.interviewers = "Justin"
        interview.addToReminder(reminder)
        apply.addToInterview(interview)
        XCTAssertNoThrow(try self.context.save())
        let reminderFetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        var reminderItems: [Reminder] = []
        XCTAssertNoThrow(reminderItems = try self.context.fetch(reminderFetchRequest))
        XCTAssertNotNil(reminderItems)
        XCTAssertEqual(reminderItems.count, 1)
        let storedReminder = reminderItems.first
        XCTAssertNotNil(storedReminder)
        let storedApply = storedReminder!.interview?.apply
        XCTAssertNotNil(storedApply)
        XCTAssertEqual(storedApply!.date, apply.date)
        XCTAssertEqual(storedApply!.status, apply.status)
        XCTAssertEqual(storedApply!.salaryExpectation, apply.salaryExpectation)
    }
    func test_ReachApply_ByReminder_WithTask() {
        let reminder = Reminder(context: self.context)
        reminder.date = Date()
        reminder.desc = "This is test honey"
        reminder.notificationID = "28596324976826345014650"
        let task = Task(context: self.context)
        task.date = Date()
        task.isDone = false
        task.deadline = Date()
        task.title = "Teeest"
        let city = City(context: self.context)
        city.name = "Barcelona"
        let country = Country(context: self.context)
        country.name = "Spain"
        country.minSalary = 48000
        country.addToCity(city)
        let company = Company(context: self.context)
        company.title = "eee"
        company.isFavorite = false
        let apply = Apply(context: self.context)
        apply.date = Date()
        apply.statusEnum = .hr
        apply.jobLink = URL(string: "test")
        city.addToApply(apply)
        let resume = Resume(context: self.context)
        resume.version = "1.5"
        resume.addToApply(apply)
        company.addToApply(apply)
        apply.addToTask(task)
        task.addToReminder(reminder)
        XCTAssertNoThrow(try self.context.save())
        let reminderFetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        var reminderItems: [Reminder] = []
        XCTAssertNoThrow(reminderItems = try self.context.fetch(reminderFetchRequest))
        XCTAssertNotNil(reminderItems)
        let storedTask = reminderItems.first!.task
        XCTAssertEqual(storedTask!.apply?.date, apply.date)
        XCTAssertEqual(storedTask!.apply?.status, apply.status)
    }
    func test_Apply_ToCompany_ByResume() {
        let city = City(context: self.context)
        city.name = "Madrid"
        let country = Country(context: self.context)
        country.name = "Spain"
        country.minSalary = 40000
        country.addToCity(city)
        let company = Company(context: self.context)
        company.title = "Gurus"
        company.isFavorite = true
        let resume = Resume(context: self.context)
        resume.version = "2.5"
        let apply = Apply(context: self.context)
        apply.date = Date()
        apply.statusEnum = .ceo
        apply.salaryExpectation = 35000
        apply.jobLink = URL(string: "https://www.google.com")
        city.addToApply(apply)
        company.addToApply(apply)
        resume.addToApply(apply)
        XCTAssertNoThrow(try self.context.save())
        let fetchCompany: NSFetchRequest<Company> = Company.fetchRequest()
        var companyItem: [Company] = []
        XCTAssertNoThrow(companyItem = try self.context.fetch(fetchCompany))
        XCTAssertEqual(companyItem.first!.apply!.count, 1)
        let storedApply = companyItem.first!.apply!.first {_ in true} as? Apply
        XCTAssertEqual(storedApply!.status, apply.status)
        XCTAssertEqual(storedApply!.salaryExpectation, apply.salaryExpectation)
        XCTAssertEqual(storedApply!.jobLink, apply.jobLink)
        XCTAssertEqual(storedApply!.resume, apply.resume)
    }
    func test_Apply_ToCountry_ByCity() {
        let city = City(context: self.context)
        city.name = "Berlin"
        let country = Country(context: self.context)
        country.name = "Germany"
        country.minSalary = 7365476
        country.addToCity(city)
        let company = Company(context: self.context)
        company.title = "eGym"
        company.isFavorite = true
        let resume = Resume(context: self.context)
        resume.version = "6.3.2"
        let apply = Apply(context: self.context)
        apply.date = Date()
        apply.statusEnum = .contract
        apply.salaryExpectation = 54000
        apply.jobLink = URL(string: "https://www.test.com")
        resume.addToApply(apply)
        company.addToApply(apply)
        city.addToApply(apply)
        XCTAssertNoThrow(try self.context.save())
        let fetchRequest: NSFetchRequest<Apply> = Apply.fetchRequest()
        var applyItem: [Apply] = []
        XCTAssertNoThrow(applyItem = try self.context.fetch(fetchRequest))
        XCTAssertEqual(applyItem.count, 1)
        let countryStored = applyItem.first!.city?.country
        XCTAssertNotNil(countryStored)
        XCTAssertEqual(countryStored, country)
    }
    func test_Tag_OnApply() {
        let tag = Tag(context: self.context)
        tag.title = "RxSwift"
        let country = Country(context: self.context)
        country.name = "US"
        country.minSalary = 100000
        let city = City(context: self.context)
        city.name = "LA"
        country.addToCity(city)
        let apply = Apply(context: self.context)
        apply.date = Date()
        apply.statusEnum = .contract
        apply.jobLink = URL(string: "test")
        city.addToApply(apply)
        let resume = Resume(context: self.context)
        resume.version = "3.1"
        resume.addToApply(apply)
        let company = Company(context: self.context)
        company.title = "Apple"
        company.isFavorite = true
        company.addToApply(apply)
        apply.addToTag(tag)
        XCTAssertNoThrow(try self.context.save())
        let fetchTagRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        var tagItem: [Tag] = []
        XCTAssertNoThrow(tagItem = try self.context.fetch(fetchTagRequest))
        XCTAssertEqual(tagItem.count, 1)
        let storeApply = tagItem.first!.apply?.first { _ in true} as? Apply
        XCTAssertEqual(storeApply!.date, apply.date)
        XCTAssertEqual(storeApply!.status, apply.status)
        XCTAssertEqual(storeApply!.jobLink, apply.jobLink)
    }
    func test_Tag_OnInterview() {
        let tag = Tag(context: self.context)
        tag.title = "Swift"
        let interview = Interview(context: self.context)
        interview.date = Date()
        interview.interviewers = "Alex"
        interview.interviewerRoleEnum = .tech
        interview.addToTag(tag)
        let city = City(context: self.context)
        city.name = "VA"
        let country = Country(context: self.context)
        country.name = "US"
        country.minSalary = 130000
        country.addToCity(city)
        let apply = Apply(context: self.context)
        apply.date = Date()
        apply.statusEnum = .inSite
        apply.jobLink = URL(string: "jobtest")
        apply.addToInterview(interview)
        city.addToApply(apply)
        let company = Company(context: self.context)
        company.title = "LG"
        company.isFavorite = false
        company.addToApply(apply)
        let resume = Resume(context: self.context)
        resume.version = "2.3"
        resume.addToApply(apply)
        XCTAssertNoThrow(try self.context.save())
        let fetchTagRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        var tagItem: [Tag] = []
        XCTAssertNoThrow(tagItem = try self.context.fetch(fetchTagRequest))
        let interviewStored = tagItem.first!.interview?.first { _ in true} as? Interview
        XCTAssertEqual(interviewStored!.date, interview.date)
        XCTAssertEqual(interviewStored!.interviewers, interview.interviewers)
        XCTAssertEqual(interviewStored?.interviewerRole, interview.interviewerRole)
    }
    func test_Interview_ToApply_ByTag() {
        let tag = Tag(context: self.context)
        tag.title = "Json"
        let interview = Interview(context: self.context)
        interview.date = Date()
        interview.interviewers = "Sofia"
        interview.interviewerRoleEnum = .tech
        interview.addToTag(tag)
        let city = City(context: self.context)
        city.name = "Germany"
        let country = Country(context: self.context)
        country.name = "Berlin"
        country.minSalary = 60000
        country.addToCity(city)
        let apply = Apply(context: self.context)
        apply.date = Date()
        apply.statusEnum = .hr
        apply.jobLink = URL(string: "jobtest")
        apply.addToInterview(interview)
        apply.addToTag(tag)
        city.addToApply(apply)
        let company = Company(context: self.context)
        company.title = "Zalando"
        company.isFavorite = true
        company.addToApply(apply)
        let resume = Resume(context: self.context)
        resume.version = "2.2"
        resume.addToApply(apply)
        XCTAssertNoThrow(try self.context.save())
        let fetchInterviewRequest: NSFetchRequest<Interview> = Interview.fetchRequest()
        var interviewItem: [Interview] = []
        XCTAssertNoThrow(interviewItem = try self.context.fetch(fetchInterviewRequest))
        XCTAssertEqual(interviewItem.count, 1)
        let tagStored = interviewItem.first?.tag?.first { _ in true} as? Tag
        XCTAssertNotNil(tagStored)
        XCTAssertEqual(tagStored!.apply?.count, 1)
        let applyStored = tagStored?.apply?.first{ _ in true} as? Apply
        XCTAssertNotNil(applyStored)
        XCTAssertEqual(applyStored!.company?.title, company.title)
    }
}
