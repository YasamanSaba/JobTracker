//
//  DataInitializer.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

struct DataInitializer {
    static func importInitialData() {
        // MARK: - Checking first time -
        guard !UserDefaults.standard.bool(forKey: "FirstTime") else {return}
        // MARK: - Reach Context -
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // MARK: - Create Country -
        let world = Country(context: context)
        world.name = "World"
        world.flag = "🌍"
        let germany = Country(context: context)
        germany.name = "Germany"
        germany.flag = "🇩🇪"
        let spain = Country(context: context)
        spain.name = "Spain"
        spain.flag = "🇪🇸"
        let france = Country(context: context)
        france.name = "France"
        france.flag = "🇫🇷"
        let portugal = Country(context: context)
        portugal.name = "Portugal"
        portugal.flag = "🇵🇹"
        let poland = Country(context: context)
        poland.name = "Poland"
        poland.flag = "🇵🇱"
        let netherland = Country(context: context)
        netherland.name = "Netherland"
        netherland.flag = "🇳🇱"
        let austria = Country(context: context)
        austria.name = "Austria"
        austria.flag = "🇦🇹"
        let belgium = Country(context: context)
        belgium.name = "Belgium"
        belgium.flag = "🇧🇪"
        let england = Country(context: context)
        england.name = "UK"
        england.flag = "🇬🇧"
        let luxembourg = Country(context: context)
        luxembourg.name = "Luxembourg"
        luxembourg.flag = "🇱🇺"
        
        let berlin = City(context: context)
        berlin.name = "Berlin"
        let munich = City(context: context)
        munich.name = "Munich"
        let frankfurt = City(context: context)
        frankfurt.name = "Frankfurt"
        germany.addToCity(berlin)
        germany.addToCity(munich)
        germany.addToCity(frankfurt)
        
        let london = City(context: context)
        london.name = "London"
        let manchester = City(context: context)
        manchester.name = "Manchester"
        england.addToCity(london)
        england.addToCity(manchester)
        
        let barcelona = City(context: context)
        barcelona.name = "Barcelona"
        spain.addToCity(barcelona)
        
        let vienna = City(context: context)
        vienna.name = "Vienna"
        austria.addToCity(vienna)
        
        let brussels = City(context: context)
        brussels.name = "Brussels"
        belgium.addToCity(brussels)
        
        // Temporary
        let date = Date()
        var components = DateComponents()
        components.setValue(-2, for: .month)
        let interview = Interview(context: context)
        interview.date = Date()
        interview.interviewerRoleEnum = .ceo
        let company = Company(context: context)
        company.title = "Fly"
        company.isFavorite = true
        let apply = Apply(context: context)
        apply.date = Calendar.current.date(byAdding: components, to: date)
        apply.statusEnum = .challenge
        apply.jobLink = URL(string: "google")
        brussels.addToApply(apply)
        let resume = Resume(context: context)
        resume.version = "1.4.5"
        resume.addToApply(apply)
        company.addToApply(apply)
        apply.addToInterview(interview)
        
        let interview2 = Interview(context: context)
        let date2 = Date()
        var components2 = DateComponents()
        components2.setValue(-3, for: .month)
        let expirationDate2 = Calendar.current.date(byAdding: components2, to: date2)
        interview2.date = expirationDate2
        interview2.interviewerRoleEnum = .recruiter
        interview2.link = URL(string: "google.com")
        interview2.interviewers = "Sam va bacheha"
        interview2.desc = "salam khobi bache joon"
        let tag = Tag(context: context)
        tag.title = "Swift"
        interview2.addToTag(tag)
        let company2 = Company(context: context)
        company2.title = "eGym"
        company2.isFavorite = false
        let apply2 = Apply(context: context)
        components2.setValue(-7, for: .day)
        apply2.date = Calendar.current.date(byAdding: components2, to: Date())
        apply2.statusEnum = .contract
        apply2.jobLink = URL(string: "google")
        vienna.addToApply(apply2)
        let resume2 = Resume(context: context)
        resume2.version = "3.5.1"
        resume2.addToApply(apply2)
        company2.addToApply(apply2)
        apply2.addToInterview(interview2)
        
        let interview3 = Interview(context: context)
        let date3 = Date()
        var components3 = DateComponents()
        components3.setValue(-8, for: .month)
        let expirationDate3 = Calendar.current.date(byAdding: components3, to: date3)
        interview3.date = expirationDate3
        interview3.interviewerRoleEnum = .tech
        let company3 = Company(context: context)
        company3.title = "Starbox"
        company3.isFavorite = true
        let apply3 = Apply(context: context)
        apply3.date = Calendar.current.date(byAdding: components3, to: date3)
        apply3.statusEnum = .rejected
        apply3.jobLink = URL(string: "google")
        barcelona.addToApply(apply3)
        let resume3 = Resume(context: context)
        resume3.version = "2.8.6"
        resume3.addToApply(apply3)
        company3.addToApply(apply3)
        apply3.addToInterview(interview3)
        
        let task = Task(context: context)
        task.date = Date()
        task.isDone = false
        task.deadline = Date()
        task.title = "Teeest"
        let date4 = Date()
        var components4 = DateComponents()
        components4.setValue(8, for: .month)
        let company4 = Company(context: context)
        company4.title = "Apple"
        company4.isFavorite = true
        let apply4 = Apply(context: context)
        apply4.date = Calendar.current.date(byAdding: components4, to: date4)
        apply4.statusEnum = .hr
        apply4.jobLink = URL(string: "test")
        munich.addToApply(apply4)
        let resume4 = Resume(context: context)
        resume4.version = "1.5.3"
        resume4.addToApply(apply4)
        company4.addToApply(apply4)
        apply4.addToTask(task)
        
        let task5 = Task(context: context)
        let date5 = Date()
        var components5 = DateComponents()
        components5.setValue(3, for: .day)
        task5.date = Calendar.current.date(byAdding: components5, to: date5)
        task5.isDone = false
        var components6 = DateComponents()
        components6.setValue(-4, for: .day)
        task5.deadline = Calendar.current.date(byAdding: components6, to: date5)
        task5.title = "Restaurant"
        let company5 = Company(context: context)
        company5.title = "Polo"
        company5.isFavorite = false
        let apply5 = Apply(context: context)
        apply5.date = Date()
        apply5.statusEnum = .inSite
        apply5.jobLink = URL(string: "test")
        manchester.addToApply(apply5)
        let resume5 = Resume(context: context)
        resume5.version = "9.5.1"
        resume5.addToApply(apply5)
        company5.addToApply(apply5)
        apply5.addToTask(task5)
        
        do {
            try context.save()
            UserDefaults.standard.set(true, forKey: "FirstTime")
        } catch {
            print(error.localizedDescription)
        }
    }
}
