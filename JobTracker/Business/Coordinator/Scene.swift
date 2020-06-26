//
//  Scene.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/22/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

enum Scene {
    case applies
    case apply
    case notes
    case note
    case tag
    case reminder(Reminderable)
}
