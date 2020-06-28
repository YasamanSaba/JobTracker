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
    var applyResultController: NSFetchedResultsController<Apply>!
    var countryResultController: NSFetchedResultsController<Country>!
    var countryDataSource: UICollectionViewDiffableDataSource<Section, Country>!
    var applyDataSource: UITableViewDiffableDataSource<Section, Apply>!
    var selectedCountryName = "World"
    let appCoordinator = (UIApplication.shared.delegate as! AppDelegate).appCoordinator
    var countryResultControllerDelegate: CountryResultControllerDelegate!
    var applyResultControllerDelegate: ApplyResultControllerDelegate!
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
        countryResultController = countryService.fetchAll()
        countryDataSource.supplementaryViewProvider = { [weak self] (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let self = self,
                let badgeView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier, for: indexPath) as? BadgeSupplementaryView else {
                    return nil
            }
            if let currentApplyObjects = self.applyResultController.fetchedObjects {
            let currentCountrySnapshot = self.countryDataSource.snapshot()
                let countryName = currentCountrySnapshot.itemIdentifiers(inSection: .main)[indexPath.row].name
            let countryCount = currentApplyObjects.filter{ $0.city?.country?.name == countryName }.count
            let count = countryName == "World" ? currentApplyObjects.count : countryCount
            badgeView.label.text = "\(count)"
            } else {
                badgeView.label.text = "0"
            }
            return badgeView
        }
        do {
            try countryResultController.performFetch()
            countryResultControllerDelegate = CountryResultControllerDelegate(countryDataSource: countryDataSource)
            countryResultController.delegate = countryResultControllerDelegate
            if let objects = countryResultController.fetchedObjects {
                let sortedObjects = objects.sorted { country1 , country2 in
                    if country1.name == "World" {
                        return true
                    }
                    var count1 = 0
                    var count2 = 0
                    country1.city?.forEach{ city in
                        let city = city as! City
                        count1 = city.apply?.count ?? 0
                    }
                    country2.city?.forEach{ city in
                        let city = city as! City
                        count2 = city.apply?.count ?? 0
                    }
                    return count1 > count2
                }
                var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Country>()
                initialSnapshot.appendSections([.main])
                initialSnapshot.appendItems(sortedObjects, toSection: .main)
                countryDataSource.apply(initialSnapshot)
            }
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
        applyResultController = applyService.fetchAll()
        do {
            try applyResultController.performFetch()
            applyResultControllerDelegate = ApplyResultControllerDelegate(applyDataSource: applyDataSource)
            applyResultController.delegate = applyResultControllerDelegate
            if let objects = applyResultController.fetchedObjects {
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
        if let objects = applyResultController.fetchedObjects {
            selectedCountryName = country.name ?? "World"
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
        if let objects = applyResultController.fetchedObjects {
            let filteredObjects = objects.filter { apply in
                return (apply.company?.title?.lowercased().contains(query.lowercased()) ?? false) && ( selectedCountryName == "World" ? true : apply.city?.country?.name == selectedCountryName)
            }
            let filteredJustByCountries = objects.filter { apply in
                selectedCountryName == "World" ? true : apply.city?.country?.name == selectedCountryName
            }
            var snapShot = NSDiffableDataSourceSnapshot<Section, Apply>()
            snapShot.appendSections([.main])
            snapShot.appendItems(query == "" ? filteredJustByCountries : filteredObjects, toSection: .main)
            applyDataSource.apply(snapShot)
        }
    }
    func showApplyDetail(for indexPath: IndexPath, sender: UIViewController) {
        let apply = applyDataSource.snapshot().itemIdentifiers[indexPath.row]
        appCoordinator?.push(scene: .apply(apply), sender: sender)
    }
    // MARK: - ApplyResultControllerDelegate
    class ApplyResultControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
        let applyDataSource: UITableViewDiffableDataSource<Section, Apply>
        
        init(applyDataSource: UITableViewDiffableDataSource<Section, Apply>) {
            self.applyDataSource = applyDataSource
        }
        
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
    class CountryResultControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
        let countryDataSource: UICollectionViewDiffableDataSource<Section, Country>
        
        init(countryDataSource: UICollectionViewDiffableDataSource<Section, Country>) {
            self.countryDataSource = countryDataSource
        }
        
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
            var diff = NSDiffableDataSourceSnapshot<Section, Country>()
            snapshot.sectionIdentifiers.forEach { _ in
                diff.appendSections([.main])
                let items = snapshot.itemIdentifiers.map { (objectId: Any) -> Country in
                    let oid = objectId as! NSManagedObjectID
                    return controller.managedObjectContext.object(with: oid) as! Country
                }
                let sortedObjects = items.sorted { country1 , country2 in
                    if country1.name == "World" {
                        return true
                    }
                    var count1 = 0
                    var count2 = 0
                    country1.city?.forEach{ city in
                        let city = city as! City
                        count1 = city.apply?.count ?? 0
                    }
                    country2.city?.forEach{ city in
                        let city = city as! City
                        count2 = city.apply?.count ?? 0
                    }
                    return count1 > count2
                }
                diff.appendItems(sortedObjects, toSection: .main)
                countryDataSource.apply(diff)
            }
        }
        
    }
}
