//
//  StateService.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 7/2/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import CoreData

struct StateService: StateServiceType {
    let context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    func getAllState() -> [Status] {
        Status.allCases
    }
}
