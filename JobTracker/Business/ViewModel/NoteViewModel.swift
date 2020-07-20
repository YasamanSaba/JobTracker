//
//  NoteViewModel.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/23/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

class NoteViewModel: CoordinatorSupportedViewModel {
    // MARK: - Properties
    weak var delegate: NoteViewModelDelegate?
    var coordinator: CoordinatorType!
    let noteService: NoteServiceType
    var note: Note? {
        didSet{
            if note != nil {
                isEditingMode = true
            }
        }
    }
    var isEditingMode: Bool = false
    // MARK: - Initializer
    init(note: Note?, noteService: NoteServiceType) {
        self.note = note
        if note != nil {
            isEditingMode = true
        }
        self.noteService = noteService
    }
    // MARK: - Functions
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
    func start() {
        if isEditingMode {
            delegate?.title(text: note!.title ?? "")
            delegate?.body(text: note!.body ?? "")
        }
    }
}
