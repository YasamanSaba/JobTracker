//
//  CountryViewModel.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class CountryViewModel: NSObject, CoordinatorSupportedViewModel {
    // MARK: - Properties
    weak var delegate: CountryViewModelDelegate?
    var coordinator: CoordinatorType!
    let countryService: CountryServiceType
    var countryResultsController: NSFetchedResultsController<Country>?
    var countryDataSource: UICollectionViewDiffableDataSource<Int,Country>?
    // MARK: - Initializer
    init(countryService: CountryServiceType) {
        self.countryService = countryService
    }
    // MARK: - Functions
    private func configure(collectionView: UICollectionView) {
        countryDataSource = UICollectionViewDiffableDataSource<Int,Country>(collectionView: collectionView){ (collectionView, indexPath, country) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCollectionViewCell.reuseIdentifier, for: indexPath) as? CountryCollectionViewCell else { return nil}
            
            cell.configure(country: country)
            return cell
        }
        countryResultsController = countryService.fetchAll()
        countryResultsController?.delegate = self
        do {
            try countryResultsController?.performFetch()
            if let objects = countryResultsController?.fetchedObjects {
                var snapShot = NSDiffableDataSourceSnapshot<Int,Country>()
                snapShot.appendSections([1])
                snapShot.appendItems(objects.filter({$0.name != "World"}), toSection: 1)
                countryDataSource?.apply(snapShot)
            }
        } catch {
            print(error)
        }
    }
    func add(name:String, flag: String) {
        do {
            try countryService.add(name: name, flag: flag)
        } catch {
            delegate?.error(text: "This country already exists.")
        }
    }
    func filter(by text: String) {
        if let objects = countryResultsController?.fetchedObjects {
            var snapShot = NSDiffableDataSourceSnapshot<Int,Country>()
            let filteredObjects = objects.filter({$0.name != "World"}).filter{ $0.name?.lowercased().contains(text.lowercased()) ?? false}
            snapShot.appendSections([1])
            snapShot.appendItems(text == "" ? objects.filter({$0.name != "World"}) : filteredObjects, toSection: 1)
            countryDataSource?.apply(snapShot)
        }
    }
    func start(collectionView: UICollectionView) {
        configure(collectionView: collectionView)
    }
}
// MARK: - Extensions
extension CountryViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var newSnapShot = NSDiffableDataSourceSnapshot<Int,Country>()
        snapshot.sectionIdentifiers.forEach { section in
            newSnapShot.appendSections([1])
            let items = snapshot.itemIdentifiersInSection(withIdentifier: section).map{ (objectId: Any) -> Country in
                let oid =  objectId as! NSManagedObjectID
                return controller.managedObjectContext.object(with: oid) as! Country
            }
            newSnapShot.appendItems(items.filter({$0.name != "World"}), toSection: 1)
        }
        countryDataSource?.apply(newSnapShot)
    }
}
