//
//  Interview+CoreDataClass.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/8/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//
//

import Foundation
import CoreData

enum InterviewerRole: Int16 {
    case hr = 1
    case recruiter = 2
    case tech = 3
    case ceo = 4
}

@objc(Interview)
public class Interview: NSManagedObject {
    var interviewerRoleEnum: InterviewerRole? {
        get {
            guard let newItem = InterviewerRole(rawValue: self.interviewerRole) else {
                return nil
            }
            return newItem
        }
        set {
            self.interviewerRole = newValue?.rawValue ?? 0
        }
    }
}
