//
//  InMemoryStore.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/10/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData


class InMemoryStore {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "JobTracker")
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
