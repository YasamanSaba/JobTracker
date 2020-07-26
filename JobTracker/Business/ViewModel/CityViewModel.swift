//
//  CityViewModel.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/1/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class CityViewModel: NSObject, CoordinatorSupportedViewModel {
    // MARK: - Properties
    weak var delegate: CityViewModelDelegate?
    var coordinator: CoordinatorType!
    let country: Country
    let cityService: CityServiceType
    var cityResultsController: NSFetchedResultsController<City>?
    var cityDataSource: UICollectionViewDiffableDataSource<Int,City>?
    // MARK: - Initializer
    init(country: Country, cityService: CityServiceType) {
        self.country = country
        self.cityService = cityService
    }
    // MARK: - Functions
    private func configure(collectionView: UICollectionView) {
        cityDataSource = UICollectionViewDiffableDataSource<Int,City>(collectionView: collectionView){ (collectionView, indexPath, city) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCollectionViewCell.reuseIdentifier, for: indexPath) as? CityCollectionViewCell else { return nil}
            
            cell.configure(city: city) { [weak self] city in
                guard let self = self else { return }
                self.delegate?.deleteConfirmation {
                    if $0 {
                        do {
                            try self.cityService.delete(city: city)
                        } catch CityServiceError.cityHasOtherRelation {
                            self.delegate?.error(text: "There is some applies on this city")
                        } catch {
                            self.delegate?.error(text: "Something is wrong, try later")
                        }
                    }
                }
            }
            return cell
        }
        cityResultsController = cityService.fetchAll(in: country)
        cityResultsController?.delegate = self
        do {
            try cityResultsController?.performFetch()
            if let objects = cityResultsController?.fetchedObjects {
                var snapShot = NSDiffableDataSourceSnapshot<Int,City>()
                snapShot.appendSections([1])
                snapShot.appendItems(objects, toSection: 1)
                cityDataSource?.apply(snapShot)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    func add(name:String) {
        do {
            try cityService.add(name: name, to: country)
        } catch {
            delegate?.error(text: "This city already exists.")
        }
    }
    func filter(by text: String) {
        if let objects = cityResultsController?.fetchedObjects {
            var snapShot = NSDiffableDataSourceSnapshot<Int,City>()
            let filteredObjects = objects.filter{ $0.name?.lowercased().contains(text.lowercased()) ?? false}
            snapShot.appendSections([1])
            snapShot.appendItems(text == "" ? objects : filteredObjects, toSection: 1)
            cityDataSource?.apply(snapShot)
        }
    }
    func getCountry() -> (String,String) {
        return (country.name ?? "" ,country.flag ?? "")
    }
    func start(collectionView: UICollectionView) {
        configure(collectionView: collectionView)
    }
}
// MARK: - Extension
extension CityViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var newSnapShot = NSDiffableDataSourceSnapshot<Int,City>()
        snapshot.sectionIdentifiers.forEach { section in
            newSnapShot.appendSections([1])
            let items = snapshot.itemIdentifiersInSection(withIdentifier: section).map{ (objectId: Any) -> City in
                let oid =  objectId as! NSManagedObjectID
                return controller.managedObjectContext.object(with: oid) as! City
            }
            newSnapShot.appendItems(items, toSection: 1)
        }
        cityDataSource?.apply(newSnapShot)
    }
}
