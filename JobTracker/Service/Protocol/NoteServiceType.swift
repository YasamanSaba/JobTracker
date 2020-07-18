//
//  NoteServiceType.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/18/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import CoreData

enum NoteServiceError: Error {
    case saveError
}

protocol NoteServiceType {
    func getAll() -> NSFetchedResultsController<Note>
    func add(title: String, body: String) throws
    func update(title: String?, body: String?, for note: Note) throws
    func delete(note: Note) throws 
}
