//
//  Apply+CoreDataClass.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/8/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//
//

import Foundation
import CoreData

enum Status: String, CaseIterable {
    case hr = "HR"
    case tech = "Technical"
    case challenge = "Challenge"
    case inSite = "inSite"
    case ceo = "CEO"
    case rejected = "Rejected"
    case contract = "Contract"
}

@objc(Apply)
public class Apply: NSManagedObject {
    var statusEnum: Status? {
        get {
            guard let newItem = Status(rawValue: self.status ?? "") else {
                return nil
            }
            return newItem
        }
        set {
            self.status = newValue?.rawValue ?? ""
        }
    }
}
