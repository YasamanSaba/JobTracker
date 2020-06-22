//
//  fwfwefwfr.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

enum CountryServiceError: Error {
    case fetchError
}

protocol CountryServiceType {
    func fetchAll() throws -> [Country]
}
