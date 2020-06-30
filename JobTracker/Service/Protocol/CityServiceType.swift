//
//  CityServiceType.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/28/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import CoreData

protocol CityServiceType {
    func fetchAll(in country: Country) -> NSFetchedResultsController<City>
}
