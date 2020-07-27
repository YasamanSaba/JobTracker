//
//  ChecklistViewMode.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/13/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class ChecklistViewModel: NSObject, CoordinatorSupportedViewModel {
    
    var coordinator: CoordinatorType!
    var delegate: ChecklistViewModelDelegate?
    private let apply: Apply
    private let checklistService: ChecklistServiceType
    private var checklistDataSource: CheckListDataSource?
    private var checklistResultsController: NSFetchedResultsController<CheckListItem>?
    
    // MARK: - Initializer
    init(apply: Apply, checklistService: ChecklistServiceType) {
        self.apply = apply
        self.checklistService = checklistService
    }
    
    // MARK: - Private Functions
    private func configure(tableView: UITableView) {
        checklistDataSource = CheckListDataSource(tableView: tableView) { (tableView, indexPath, wrappedItem) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChecklistItemTableViewCell.reuseIdentifier) as? ChecklistItemTableViewCell else {
                return nil
            }
            cell.configure(title: wrappedItem.item.title, isDone: wrappedItem.item.isDone)
            return cell
        }
        checklistDataSource?.checklistService = checklistService
        checklistDataSource?.superDelegate = delegate
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
    
    // MARK: - Public API
    func start(tableView: UITableView) {
        configure(tableView: tableView)
    }
    func add(title: String) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            delegate?.error(text: GeneralMessages.addEmptyItem.rawValue)
            return
        }
        do {
            try checklistService.add(title: title, for: apply)
        } catch _ as ChecklistServiceError {
            delegate?.error(text: GeneralMessages.unknown.rawValue)
        } catch {
            delegate?.error(text: GeneralMessages.unknown.rawValue)
        }
    }
    func selectItem(at indexPath: IndexPath, tableView: UITableView) {
        if var item = checklistDataSource?.snapshot().itemIdentifiers[indexPath.row], let cell = checklistDataSource?.tableView(tableView, cellForRowAt: indexPath) as? ChecklistItemTableViewCell {
            do {
                item.isDone.toggle()
                try checklistService.set(isDone: !item.item.isDone, for: item.item)
                cell.isDone.toggle()
            } catch {
                delegate?.error(text: GeneralMessages.unknown.rawValue)
            }
        }
    }
    
    // MARK: - Nested Types
    private class CheckListDataSource: UITableViewDiffableDataSource<Int,WrappedItem>, NSFetchedResultsControllerDelegate {
        var checklistService: ChecklistServiceType?
        var superDelegate: ChecklistViewModelDelegate?
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
                    superDelegate?.deleteConfirmation() { [weak self] in
                        if $0 {
                            do {
                                try self?.checklistService?.delete(item: identifierToDelete.item)
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
        }
    }
    struct WrappedItem: Hashable {
        let item: CheckListItem
        var isDone: Bool
    }
}
