//
//  ApplyViewModel.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/25/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

struct ApplyViewModel {
    let service: ApplyServiceType
    init(service: ApplyServiceType) {
        self.service = service
    }
    func getAllState() -> [String] {
        return service.getAllState()
    }
}
