//
//  ApplyService.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/20/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

struct ApplyService: ApplyServiceType {
    let context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    func getAllState() -> [String] {
        var result: [String] = []
        Status.allCases.forEach { state in
            switch state {
            case .ceo:
                result.append("CEO")
            case .challenge:
                result.append("Challenge")
            case .contract:
                result.append("Contract")
            case .hr:
                result.append("HR")
            case .inSite:
                result.append("inSite")
            case .rejected:
                result.append("Rejected")
            case .tech:
                result.append("Technical")
            }
        }
        return result
    }
    
    func fetchAll() -> NSFetchedResultsController<Apply> {
        let fetchRequest: NSFetchRequest<Apply> = Apply.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Apply.date), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
}
