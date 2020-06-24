//
//  NotesViewModel.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/23/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

class NotesViewModel: CoordinatorSupportedViewModel {
    var coordinator: CoordinatorType!
    
    init(coordinator: CoordinatorType!) {
        self.coordinator = coordinator
    }
}
