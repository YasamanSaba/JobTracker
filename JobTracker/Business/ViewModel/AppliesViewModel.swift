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
    //var countryResultController: NSFetchedResultsController<Country>!
    var countryDataSource: UICollectionViewDiffableDataSource<Section, Country>?
    var applyDataSource: ApplyDataSource!
    var selectedCountry: Country!
    let world: Country
    let appCoordinator = (UIApplication.shared.delegate as! AppDelegate).appCoordinator
    //var countryResultControllerDelegate: CountryResultControllerDelegate!
    var applyResultControllerDelegate: ApplyResultControllerDelegate!
    var onFilterChanged: ((Bool) -> Void)?
    // MARK: - Initialization -
    init(countryService: CountryServiceType, applyService: ApplyServiceType) {
        self.countryService = countryService
        self.applyService = applyService
        world = try! countryService.getWorld()
        selectedCountry = world
    }
    // MARK: - Functions -
    func configureCountryDataSource(for collectionView: UICollectionView) {
        countryDataSource = UICollectionViewDiffableDataSource<Section, Country>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlagCollectinViewCell.reuseIdentifier, for: indexPath) as! FlagCollectinViewCell
            cell.lblCountryName.text = item.name
            cell.lblFlag.text = item.flag
            return cell
        }
        //countryResultController = countryService.fetchAll()
        countryDataSource?.supplementaryViewProvider = { [weak self] (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let self = self,
                let badgeView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier, for: indexPath) as? BadgeSupplementaryView else {
                    return nil
            }
            if let currentApplyObjects = self.applyResultController.fetchedObjects {
                let currentCountrySnapshot = self.countryDataSource?.snapshot()
                let countryName = currentCountrySnapshot?.itemIdentifiers(inSection: .main)[indexPath.row].name
                let countryCount = currentApplyObjects.filter{ $0.city?.country?.name == countryName }.count
                let count = countryName == "World" ? currentApplyObjects.count : countryCount
                badgeView.label.text = "\(count)"
            } else {
                badgeView.label.text = "0"
            }
            return badgeView
        }
        updateCountryDataSource()
        /*
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
        }*/
    }
    func updateCountryDataSource() {
        let currentApplySnapshot = applyDataSource.snapshot()
        var snapShot = NSDiffableDataSourceSnapshot<Section, Country>()
        snapShot.appendSections([.main])
        var countries = currentApplySnapshot.itemIdentifiers.map {$0.city!.country!}
        if let world = try? countryService.getWorld() {
            countries.insert(world, at: 0)
        }
        snapShot.appendItems(countries, toSection: .main)
        countryDataSource?.apply(snapShot)
    }
    func configureApplyDataSource(for tableView: UITableView) {
        applyDataSource = ApplyDataSource(tableView: tableView) { (tableView, indexPath, apply) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ApplyTableViewCell.reuseIdentifier, for: indexPath) as? ApplyTableViewCell else { return nil }
            cell.configure(apply: apply)
            return cell
        }
        applyDataSource.applyService = applyService
        applyDataSource.countryUpdater = updateCountryDataSource
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
            print(error.localizedDescription)
        }
    }
    func selectCountry(at indexPath: IndexPath) {
        guard let country = countryDataSource?.itemIdentifier(for: indexPath) else { return }
        if let objects = applyResultController.fetchedObjects {
            selectedCountry = country
            let filteredObjects = objects.filter { apply in
                apply.city?.country?.name == country.name
            }
            var snapShot = NSDiffableDataSourceSnapshot<Section, Apply>()
            snapShot.appendSections([.main])
            snapShot.appendItems(country.name == world.name ? objects : filteredObjects, toSection: .main)
            applyDataSource.apply(snapShot)
        }
    }
    func filterCompanies(for query: String) {
        if let objects = applyResultController.fetchedObjects {
            let filteredObjects = objects.filter { apply in
                return (apply.company?.title?.lowercased().contains(query.lowercased()) ?? false) && ( selectedCountry.name == world.name ? true : apply.city?.country?.name == selectedCountry.name)
            }
            let filteredJustByCountries = objects.filter { apply in
                selectedCountry.name == world.name ? true : apply.city?.country?.name == selectedCountry.name
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
    func deleteApplies(indexPaths: [IndexPath]) {
        var currentSnapshot = applyDataSource.snapshot()
        let applies = currentSnapshot.itemIdentifiers.enumerated().filter { index, apply in
            indexPaths.contains { indexPath in
                indexPath.row == index
            }
        }.map { (index, apply) -> Apply in
            do {
                try applyService.delete(apply: apply)
            } catch {
                print(error.localizedDescription)
            }
            return apply
        }
        currentSnapshot.deleteItems(applies)
        applyDataSource.apply(currentSnapshot)
    }
    func addApply(sender: UIViewController) {
        appCoordinator?.push(scene: .newApply, sender: sender)
    }
    func filter(sender: UIViewController) {
        appCoordinator?.present(scene: .filter(selectedCountry,applyFilter(filters:hasInterview:hasTask:isCompanyFavorite:)), sender: sender)
    }
    func applyFilter(filters:[FilterViewModel.FilterObject], hasInterview:Bool, hasTask:Bool, isCompanyFavorite: Bool) {
        guard filters.count > 0 else {return}
        let currentApplies = applyDataSource.snapshot().itemIdentifiers
        var filteredCityApplies: [Apply] = []
        var filteredStateApplies: [Apply] = []
        var filteredTagApplies: [Apply] = []
        var filteredDateApplies: [Apply] = []
        var hasSelectedCity = false
        var hasSelectedTag = false
        var hasSelectedState = false
        var hasSelectedDate = false
        
        filters.forEach { filter in
            switch filter.filterType {
            case .city:
                hasSelectedCity = true
                filteredCityApplies.append(contentsOf: currentApplies.filter({$0.city == filter.city}))
            case .state:
                hasSelectedState = true
                filteredStateApplies.append(contentsOf: currentApplies.filter({$0.statusEnum == filter.state}))
            case .tag:
                hasSelectedTag = true
                filteredTagApplies.append(contentsOf: currentApplies.filter({$0.tag!.contains(filter.tag!)}))
            case .date:
                hasSelectedDate = true
                if let from = filter.date?.from, filter.date?.to == nil {
                filteredDateApplies.append(contentsOf: currentApplies.filter({$0.date! >= from}))
                }
                if let to = filter.date?.to, filter.date?.from == nil {
                    filteredDateApplies.append(contentsOf: currentApplies.filter({$0.date! <= to}))
                }
                if let from = filter.date?.from, let to = filter.date?.to {
                    filteredDateApplies.append(contentsOf: currentApplies.filter({from <= $0.date! && to > $0.date!}))
                }
            }
        }
        var result = Set(currentApplies)
        let filteredCityAppliesSet = Set(filteredCityApplies)
        let filteredStateAppliesSet = Set(filteredStateApplies)
        let filteredTagAppliesSet = Set(filteredTagApplies)
        let filteredDateAppliesSet = Set(filteredDateApplies)
        
        if hasSelectedCity {
            result = result.intersection(filteredCityAppliesSet)
        }
        if hasSelectedState {
            result = result.intersection(filteredStateAppliesSet)
        }
        if hasSelectedTag {
            result = result.intersection(filteredTagAppliesSet)
        }
        if hasSelectedDate {
            result = result.intersection(filteredDateAppliesSet)
        }
        let today = Calendar.current.startOfDay(for: Date())
        if hasInterview {
            result = result.filter{ apply in
                guard let interviews = apply.interview else {return false}
                var hasFutureInterview = false
                interviews.forEach{ item in
                    if let interview = item as? Interview {
                        if interview.date! >= today {
                            hasFutureInterview = true
                        }
                    }
                }
                return hasFutureInterview
            }
        }
        if hasTask {
            result = result.filter { apply in
                guard let tasks = apply.task else { return false }
                var hasFutureTask = false
                tasks.forEach { task in
                    if let task = task as? Task {
                        if task.deadline! >= today && !task.isDone {
                            hasFutureTask = true
                        }
                    }
                }
                return hasFutureTask
            }
        }
        if isCompanyFavorite {
            result = result.filter({$0.company?.isFavorite == true})
        }
        var snapShot = NSDiffableDataSourceSnapshot<Section,Apply>()
        snapShot.appendSections([.main])
        snapShot.appendItems(Array(result), toSection: .main)
        applyDataSource.apply(snapShot)
        onFilterChanged?(true)
    }
    func isFiltered(onChanged: @escaping (Bool) -> Void) {
        self.onFilterChanged = onChanged
    }
    func resetFilters() {
        if let objects = applyResultController.fetchedObjects {
            var snapShot = NSDiffableDataSourceSnapshot<Section,Apply>()
            snapShot.appendSections([.main])
            snapShot.appendItems(objects, toSection: .main)
            applyDataSource.apply(snapShot)
            onFilterChanged?(false)
        }
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
    /*
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
    */
    class ApplyDataSource: UITableViewDiffableDataSource<Section, Apply> {
        var applyService: ApplyServiceType!
        var countryUpdater: (() -> Void)!
        override func apply(_ snapshot: NSDiffableDataSourceSnapshot<AppliesViewModel.Section, Apply>, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
            super.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
            countryUpdater()
        }
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete, let apply = itemIdentifier(for: indexPath) {
                do {
                    try applyService.delete(apply: apply)
                    var snapShot = snapshot()
                    snapShot.deleteItems([apply])
                    self.apply(snapShot )
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
