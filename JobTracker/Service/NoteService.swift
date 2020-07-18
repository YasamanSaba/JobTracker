//
//  NoteService.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/18/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import CoreData

class NoteService: NoteServiceType {
    let context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getAll() -> NSFetchedResultsController<Note> {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Note.objectID), ascending: true)
        request.sortDescriptors = [sort]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }
    
    func add(title: String, body: String) throws {
        let note = Note(context: context)
        note.title = title
        note.body = body
        do {
            try context.save()
        } catch {
            throw NoteServiceError.saveError
        }
    }
    
    func update(title: String?, body: String?, for note: Note) throws {
        if let title = title {
            note.title = title
        }
        if let body = body {
            note.body = body
        }
        do {
            try context.save()
        } catch {
            throw NoteServiceError.saveError
        }
    }
    
    func delete(note: Note) throws {
        context.delete(note)
        do {
            try context.save()
        } catch {
            throw NoteServiceError.saveError
        }
    }
    
}
