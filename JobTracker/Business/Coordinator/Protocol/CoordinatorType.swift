//
//  CoordinatorType.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/22/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

protocol CoordinatorType {
    
    func start(by tabs: [Tab])
    func push(scene: Scene, sender: Any)
    func present(scene: Scene, sender: Any)
}
