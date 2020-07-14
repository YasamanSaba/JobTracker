//
//  ChecklistViewMode.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/13/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

enum ChecklistViewModelError: String, Error {
    case general = "Please try again later."
}

struct WrappedItem: Hashable {
    let item: CheckListItem
    var isDone: Bool
}

class ChecklistViewModel: NSObject {
    
    let apply: Apply
    let checklistService: ChecklistServiceType
    var checklistDataSource: CheckListDataSource?
    var checklistResultsController: NSFetchedResultsController<CheckListItem>?
    
    init(apply: Apply, checklistService: ChecklistServiceType) {
        self.apply = apply
        self.checklistService = checklistService
    }
    
    func configure(tableView: UITableView) {
        checklistDataSource = CheckListDataSource(tableView: tableView) { (tableView, indexPath, wrappedItem) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChecklistItemTableViewCell.reuseIdentifier) as? ChecklistItemTableViewCell else {
                return nil
            }
            cell.configure(title: wrappedItem.item.title, isDone: wrappedItem.item.isDone)
            return cell
        }
        checklistDataSource?.checklistService = checklistService
        checklistResultsController = checklistService.fetchAll(for: apply)
        checklistResultsController?.delegate = checklistDataSource
        do {
            try checklistResultsController?.performFetch()
            if let objects = checklistResultsController?.fetchedObjects {
                var snapshot = NSDiffableDataSourceSnapshot<Int,WrappedItem>()
                snapshot.appendSections([1])
                snapshot.appendItems(objects.map{WrappedItem(item: $0,isDone: $0.isDone)}
                    , toSection: 1)
                checklistDataSource?.apply(snapshot)
            }
        } catch {
            
        }
    }
    
    func add(title: String) throws {
        do {
            try checklistService.add(title: title, for: apply)
        } catch _ as ChecklistServiceError {
            throw ChecklistViewModelError.general
        } catch {
            print(error)
        }
    }
    
    func selectItem(at indexPath: IndexPath, tableView: UITableView) throws {
        if var item = checklistDataSource?.snapshot().itemIdentifiers[indexPath.row], let cell = checklistDataSource?.tableView(tableView, cellForRowAt: indexPath) as? ChecklistItemTableViewCell {
            do {
                item.isDone.toggle()
                try checklistService.set(isDone: !item.item.isDone, for: item.item)
                cell.isDone.toggle()
            } catch {
                throw ChecklistViewModelError.general
            }
        }
    }
    
    class CheckListDataSource: UITableViewDiffableDataSource<Int,WrappedItem>, NSFetchedResultsControllerDelegate {
        var checklistService: ChecklistServiceType?
        
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
            var newSnapshot = NSDiffableDataSourceSnapshot<Int,WrappedItem>()
            snapshot.sectionIdentifiers.forEach{ _ in
                newSnapshot.appendSections([1])
                let items = snapshot.itemIdentifiers.map { (id: Any) -> WrappedItem in
                    let item = controller.managedObjectContext.object(with: id as! NSManagedObjectID) as! CheckListItem
                    return WrappedItem(item: item, isDone: item.isDone)
                }
                newSnapshot.appendItems(items, toSection: 1)
            }
            self.apply(newSnapshot,animatingDifferences: false)
        }
        
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let identifierToDelete = itemIdentifier(for: indexPath) {
                    do {
                        try checklistService?.delete(item: identifierToDelete.item)
                        var snapshot = self.snapshot()
                        snapshot.deleteItems([identifierToDelete])
                        apply(snapshot)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
