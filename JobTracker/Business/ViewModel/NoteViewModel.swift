//
//  NoteViewModel.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/23/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

enum NoteViewModelError: String, Error {
    case unknown = "Something went wrong, try again later."
}

class NoteViewModel {
    
    struct InitialValues {
        let title: String
        let body: String
    }
    
    var note: Note? {
        didSet{
            if note != nil {
                isEditingMode = true
            }
        }
    }
    let noteService: NoteServiceType
    
    var isEditingMode: Bool = false
    
    init(note: Note?, noteService: NoteServiceType) {
        self.note = note
        if note != nil {
            isEditingMode = true
        }
        self.noteService = noteService
    }
    
    func getInitialValues() -> InitialValues? {
        if isEditingMode {
            return InitialValues(title: note!.title ?? "", body: note!.body ?? "")
        } else {
            return nil
        }
    }
    
    func save(title: String, body: String) throws {
        do {
            if isEditingMode {
                try noteService.update(title: title, body: body, for: note!)
            } else {
                try noteService.add(title: title, body: body)
            }
        } catch {
            throw NoteViewModelError.unknown
        }
    }
}
