//
//  StateServiceType.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 7/2/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

enum StateServiceError: Error {
    case fetchError
}

protocol StateServiceType {
    func getAllState() -> [Status]
}
