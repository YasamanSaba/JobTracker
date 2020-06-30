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

enum InterviewerRole: String {
    case hr = "HR"
    case recruiter = "Recruiter"
    case tech = "Technical"
    case ceo = "CEO"
}

@objc(Interview)
public class Interview: NSManagedObject {
    var interviewerRoleEnum: InterviewerRole? {
        get {
            guard let newItem = InterviewerRole(rawValue: self.interviewerRole ?? "") else {
                return nil
            }
            return newItem
        }
        set {
            self.interviewerRole = newValue?.rawValue ?? ""
        }
    }
}
