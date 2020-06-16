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
        guard !UserDefaults.standard.bool(forKey: "FirstTime") else {return}
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let germany = Country(context: context)
        germany.name = "Germany"
        germany.flag = "🇩🇪"
        let spain = Country(context: context)
        spain.name = "Spain"
        spain.flag = "🇮🇹"
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
        england.name = "England"
        england.flag = "🏴󠁧󠁢󠁥󠁮󠁧󠁿"
        do {
            try context.save()
            UserDefaults.standard.set(true, forKey: "FirstTime")
        } catch {
            print(error.localizedDescription)
        }
    }
}
