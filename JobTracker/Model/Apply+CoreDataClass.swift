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

enum Status: Int16 {
    case hr = 1
    case tech = 2
    case challenge = 3
    case inSite = 4
    case ceo = 5
    case rejected = 6
    case contract = 7
}


@objc(Apply)
public class Apply: NSManagedObject {
    var statusEnum: Status? {
        get {
            guard let newItem = Status(rawValue: self.status) else {
                return nil
            }
            return newItem
        }
        set {
            self.status = newValue?.rawValue ?? 0
        }
    }
}
