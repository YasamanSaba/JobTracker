//
//  TagViewModel.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/20/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

enum TagViewModelError: String, Error {
    case alreadyExists
    case cannotDelete = "This tag is used in other objects"
}

class TagViewModel: NSObject {
    
    let service: TagServiceType
    let onCompletion: ([Tag]) -> Void
    var dataSource: TagDataSource!
    var fetchedResultController: NSFetchedResultsController<Tag>!
    var selectedTagsDataSource: UICollectionViewDiffableDataSource<Int,Tag>!
    var selectedTags: [Tag] {
        didSet {
            var snapShot = NSDiffableDataSourceSnapshot<Int,Tag>()
            snapShot.appendSections([1])
            snapShot.appendItems(selectedTags, toSection: 1)
            selectedTagsDataSource.apply(snapShot)
        }
    }
    
    init(service: TagServiceType, onCompletion: @escaping ([Tag]) -> Void, initialTags: [Tag]? = nil) {
        self.service = service
        self.onCompletion = onCompletion
        self.selectedTags = initialTags ?? []
    }
    
    func configureSelectedTags(collectionView: UICollectionView) {
        selectedTagsDataSource = UICollectionViewDiffableDataSource<Int,Tag>(collectionView: collectionView) { (collectionView, indexPath, tag) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.reuseIdentifier, for: indexPath) as? TagCollectionViewCell else { return nil}
            
            cell.configure(tag: tag) { [weak self] in
                guard let self = self else { return }
                if let index = self.selectedTags.firstIndex(of: $0) {
                    self.selectedTags.remove(at: index)
                }
            }
            return cell
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<Int,Tag>()
        snapShot.appendSections([1])
        snapShot.appendItems(selectedTags, toSection: 1)
        selectedTagsDataSource.apply(snapShot)
    }
    
    func configureDatasource(for tableView: UITableView) {
        dataSource = TagDataSource(tableView: tableView ){ (tableView, indexPath, item) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TagTableViewCell.reuseIdentifier) as? TagTableViewCell else { return nil }
            
            cell.lblTitle.text = item.title
            return cell
        }
        tableView.delegate = self
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
    
    func save() {
        onCompletion(selectedTags)
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

extension TagViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = dataSource.snapshot().itemIdentifiers[indexPath.row]
        let index = selectedTags.firstIndex(of: tag)
        if index == nil {
            selectedTags.append(tag)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
