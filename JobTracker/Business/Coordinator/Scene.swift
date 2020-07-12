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
    case apply(Apply)
    case newApply
    case notes
    case note
    case tag(([Tag]) -> Void,[Tag]?)
    case reminder(Reminderable)
    case company((Company) -> Void)
    case filter(Country, ([FilterViewModel.FilterObject], Bool, Bool, Bool) -> Void)
    case country
    case city(Country)
    case resume
    case interview
}
