//
//  NoteViewModel.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/23/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

class NoteViewModel: CoordinatorSupportedViewModel {
    
    struct InitialValues {
        let title: String
        let body: String
    }
    weak var delegate: NoteViewModelDelegate?
    var coordinator: CoordinatorType!
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
    
    func save(title: String, body: String) {
        do {
            if isEditingMode {
                try noteService.update(title: title, body: body, for: note!)
            } else {
                try noteService.add(title: title, body: body)
            }
        } catch {
            delegate?.error(text: "Unknown")
        }
    }
}
