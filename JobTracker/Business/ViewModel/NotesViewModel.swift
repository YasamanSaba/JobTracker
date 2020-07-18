//
//  NotesViewModel.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/23/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class NotesViewModel {
    
    struct NoteItem: Hashable {
        let note: Note
        let title: String
        let body: String
        init(_ note: Note) {
            self.note = note
            self.title = note.title ?? ""
            self.body = note.body ?? ""
        }
    }
    
    let appCoordinator = (UIApplication.shared.delegate as! AppDelegate).appCoordinator
    let noteService: NoteServiceType
    var noteDataSource: NoteDataSource?
    var noteResultsController: NSFetchedResultsController<Note>?
    init(noteService: NoteServiceType) {
        self.noteService = noteService
    }
    
    func add(sender: UIViewController) {
        appCoordinator?.present(scene: .note(nil), sender: sender)
    }
    func select(at indexPath: IndexPath, sender: UIViewController) {
        if let note = noteDataSource?.snapshot().itemIdentifiers[indexPath.row] {
            appCoordinator?.present(scene: .note(note.note), sender: sender)
        }
    }
    func configure(tableView: UITableView) {
        noteDataSource = NoteDataSource(tableView: tableView) {
            (tableView, indexPath, note) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier) as? NoteTableViewCell else {
                return nil
            }
            cell.configure(title: note.title)
            return cell
        }
        noteDataSource?.noteService = noteService
        noteResultsController = noteService.getAll()
        noteResultsController?.delegate = noteDataSource
        do {
            try noteResultsController?.performFetch()
            if let objects = noteResultsController?.fetchedObjects {
                var snapshot = NSDiffableDataSourceSnapshot<Int,NoteItem>()
                snapshot.appendSections([1])
                snapshot.appendItems(objects.map{NoteItem($0)},toSection: 1)
                noteDataSource?.apply(snapshot)
            }
        } catch {
            print(error
            )
        }
    }
    
    class NoteDataSource: UITableViewDiffableDataSource<Int,NoteItem>, NSFetchedResultsControllerDelegate {
        var noteService: NoteServiceType?
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
            var newSnapshot = NSDiffableDataSourceSnapshot<Int,NoteItem>()
            snapshot.sectionIdentifiers.forEach { _ in
                newSnapshot.appendSections([1])
                newSnapshot.appendItems(snapshot.itemIdentifiers.map { (objectId: Any) -> NoteItem in
                    let note = controller.managedObjectContext.object(with: objectId as! NSManagedObjectID) as! Note
                    return NoteItem(note)
                } , toSection: 1)
            }
            self.apply(newSnapshot)
        }
        
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let note = itemIdentifier(for: indexPath) {
                    try? noteService?.delete(note: note.note)
                }
            }
        }
    }
}
