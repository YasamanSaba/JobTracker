//
//  CountryViewModel.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class AppliesViewModel: NSObject {
    enum Section {
        case main
    }
    // MARK: - Properties -
    let countryService: CountryServiceType!
    let applyService: ApplyServiceType!
    var resultController: NSFetchedResultsController<Apply>!
    var countryDataSource: UICollectionViewDiffableDataSource<Section, Country>!
    var applyDataSource: UITableViewDiffableDataSource<Section, Apply>!
    // MARK: - Initialization -
    init(countryService: CountryServiceType, applyService: ApplyServiceType) {
        self.countryService = countryService
        self.applyService = applyService
    }
    // MARK: - Functions -
    func configureCountryDataSource(for collectionView: UICollectionView) {
        countryDataSource = UICollectionViewDiffableDataSource<Section, Country>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlagCollectinViewCell.reuseIdentifier, for: indexPath) as! FlagCollectinViewCell
            cell.lblCountryName.text = item.name
            cell.lblFlag.text = item.flag
            return cell
        }
        do {
            let countries = try self.countryService.fetchAll()
            var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Country>()
            initialSnapshot.appendSections([.main])
            initialSnapshot.appendItems(countries, toSection: .main)
            countryDataSource.apply(initialSnapshot)
        } catch {
            print(error.localizedDescription)
        }
    }
    func configureApplyDataSource(for tableView: UITableView) {
        applyDataSource = UITableViewDiffableDataSource<Section, Apply>(tableView: tableView) { (tableView, indexPath, apply) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ApplyTableViewCell.reuseIdentifier, for: indexPath) as? ApplyTableViewCell else { return nil }
            cell.configure(apply: apply)
            return cell
        }
        resultController = applyService.fetchAll()
        do {
            try resultController.performFetch()
            resultController.delegate = self
            if let objects = resultController.fetchedObjects {
                var snapShot = NSDiffableDataSourceSnapshot<Section, Apply>()
                snapShot.appendSections([.main])
                snapShot.appendItems(objects, toSection: .main)
                applyDataSource.apply(snapShot)
            }
        } catch {
            
        }
    }
    func selectCountry(at indexPath: IndexPath) {
        guard let country = countryDataSource.itemIdentifier(for: indexPath) else { return }
        if let objects = resultController.fetchedObjects {
            let filteredObjects = objects.filter { apply in
                apply.city?.country?.name == country.name
            }
            var snapShot = NSDiffableDataSourceSnapshot<Section, Apply>()
            snapShot.appendSections([.main])
            snapShot.appendItems(country.name == "World" ? objects : filteredObjects, toSection: .main)
            applyDataSource.apply(snapShot)
        }
    }
    
    func filterCompanies(for query: String) {
        if let objects = resultController.fetchedObjects {
            let filteredObjects = objects.filter { apply in
                return apply.company?.title?.lowercased().contains(query.lowercased()) ?? false
            }
            var snapShot = NSDiffableDataSourceSnapshot<Section, Apply>()
            snapShot.appendSections([.main])
            snapShot.appendItems(query == "" ? objects : filteredObjects, toSection: .main)
            applyDataSource.apply(snapShot)
        }
    }
}
// MARK: - Extensions-
extension AppliesViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var diff = NSDiffableDataSourceSnapshot<Section,Apply>()
        snapshot.sectionIdentifiers.forEach { _ in
            diff.appendSections([.main])
            let items = snapshot.itemIdentifiers.map { (objectId: Any) -> Apply in
                let oid =  objectId as! NSManagedObjectID
                return controller.managedObjectContext.object(with: oid) as! Apply
            }
            diff.appendItems(items, toSection: .main) }
        applyDataSource.apply(diff)
    }
}

