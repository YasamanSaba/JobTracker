//
//  TagViewModel.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/20/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

enum TagViewModelError: Error {
    case alreadyExists
}

class TagViewModel: NSObject {
    
    let service: TagServiceType
    let onCompletion: ([Tag]) -> Void
    var dataSource: TagDataSource!
    var fetchedResultController: NSFetchedResultsController<Tag>!
    
    init(service: TagServiceType, onCompletion: @escaping ([Tag]) -> Void) {
        self.service = service
        self.onCompletion = onCompletion
    }
    
    func configureDatasource(for tableView: UITableView) {
        dataSource = TagDataSource(tableView: tableView ){ (tableView, indexPath, item) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TagTableViewCell.reuseIdentifier) as? TagTableViewCell else { return nil }
            
            cell.lblTitle.text = item.title
            return cell
        }
        dataSource.service = self.service
        do
        {
            fetchedResultController = service.fetchAll()
            try fetchedResultController.performFetch()
            fetchedResultController.delegate = self
            if let objects = fetchedResultController.fetchedObjects {
                var snapShot = NSDiffableDataSourceSnapshot<Int,Tag>()
                snapShot.appendSections([1])
                snapShot.appendItems(objects, toSection: 1)
                dataSource.apply(snapShot)
            }
        } catch {
            print(error)
        }
    }
    
    func addNew(tag: String) throws {
        do {
            try service.add(tag: tag)
        } catch TagServiceError.existingTag{
            throw TagViewModelError.alreadyExists
        } catch {
            print(error)
        }
    }
    
    func filterTags(by text: String) {
        if let objects = fetchedResultController.fetchedObjects {
            var snapShot = NSDiffableDataSourceSnapshot<Int,Tag>()
            let filteredObjects = objects.filter{ $0.title?.contains(text) ?? false}
            snapShot.appendSections([1])
            snapShot.appendItems(text == "" ? objects : filteredObjects, toSection: 1)
            dataSource.apply(snapShot)
        }
    }
    
    func save(tags: [String]) {
        guard tags.count > 0 else { return }
        var result: [Tag] = []
        if let objects = fetchedResultController.fetchedObjects {
            tags.forEach{ text in
                if let tag = objects.filter({$0.title == text}).first{
                    result.append(tag)
                }
            }
        }
        onCompletion(result)
    }
    
    class TagDataSource: UITableViewDiffableDataSource<Int,Tag> {
        var service: TagServiceType!
        
        // MARK: editing support
        
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let identifierToDelete = itemIdentifier(for: indexPath) {
                    do {
                        try service.delete(tag: identifierToDelete)
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

extension TagViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var newSnapShot = NSDiffableDataSourceSnapshot<Int,Tag>()
        snapshot.sectionIdentifiers.forEach { section in
            newSnapShot.appendSections([1])
            let items = snapshot.itemIdentifiersInSection(withIdentifier: section).map{ (objectId: Any) -> Tag in
                let oid =  objectId as! NSManagedObjectID
                return controller.managedObjectContext.object(with: oid) as! Tag
            }
            newSnapShot.appendItems(items, toSection: 1)
        }
        dataSource.apply(newSnapShot)
    }
}


