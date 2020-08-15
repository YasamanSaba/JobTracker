//
//  CountryViewModel.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class AppliesViewModel: NSObject, CoordinatorSupportedViewModel {
    // MARK: - Nested Types
    enum Section {
        case main
    }
    struct CountryItem: Hashable {
        let country: Country
        let name: String?
        let flag: String?
        let minSalary: Int32?
        init(_ country: Country) {
            self.country = country
            name = country.name
            flag = country.flag
            minSalary = country.minSalary
        }
    }
    struct ApplyItem: Hashable {
        let apply: Apply
        let date: Date?
        let jobLink: URL?
        let salaryExpectation: Int32
        let status: Status
        let companyName: String
        let countryName: String
        let cityName: String
        let checklistItems: [CheckListItem]
        let completedChecklistItems: [CheckListItem]
        let companyIsFavorie: Bool
        let numberOfInterviews: Int
        let numberOfTasks: Int
        var numberOfCheckListItems: Int {
            checklistItems.count
        }
        var numberOfNotCompletedChecklistItems: Int {
            completedChecklistItems.count
        }
        init(_ apply: Apply) {
            self.apply = apply
            date = apply.date
            jobLink = apply.jobLink
            salaryExpectation = apply.salaryExpectation
            status = apply.statusEnum!
            companyName = apply.company?.title ?? ""
            countryName = apply.city?.country?.name ?? ""
            cityName = apply.city?.name ?? ""
            checklistItems = apply.checkListItem?.allObjects.map{$0 as! CheckListItem} ?? []
            completedChecklistItems = apply.checkListItem?.allObjects.map{$0 as! CheckListItem}.filter{$0.isDone} ?? []
            companyIsFavorie = apply.company?.isFavorite ?? false
            numberOfInterviews = apply.interview?.count ?? 0
            numberOfTasks = apply.task?.count ?? 0
        }
    }
    // MARK: - Properties
    weak var delegate: AppliesViewModelDelegate?
    var coordinator: CoordinatorType!
    let countryService: CountryServiceType!
    let applyService: ApplyServiceType!
    var applyResultController: NSFetchedResultsController<Apply>!
    var countryDataSource: UICollectionViewDiffableDataSource<Section, CountryItem>?
    var applyDataSource: ApplyDataSource!
    var selectedCountry: Country!
    let world: Country
    var applyResultControllerDelegate: ApplyResultControllerDelegate!
    var onFilterChanged: ((Bool) -> Void)?
    // MARK: - Initialization
    init(countryService: CountryServiceType, applyService: ApplyServiceType) {
        self.countryService = countryService
        self.applyService = applyService
        world = try! countryService.getWorld()
        selectedCountry = world
    }
    // MARK: - Functions
    private func configureCountryDataSource(for collectionView: UICollectionView) {
        countryDataSource = UICollectionViewDiffableDataSource<Section, CountryItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlagCollectinViewCell.reuseIdentifier, for: indexPath) as! FlagCollectinViewCell
            cell.configure(flag: item.flag ?? "", name: item.name ?? "")
            return cell
        }
        countryDataSource?.supplementaryViewProvider = { [weak self] (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let self = self,
                let badgeView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier, for: indexPath) as? BadgeSupplementaryView else {
                    return nil
            }
            let currentApplyObjects = self.applyDataSource.snapshot().itemIdentifiers
            if  currentApplyObjects.count > 0 {
                let currentCountrySnapshot = self.countryDataSource?.snapshot()
                let countryName = currentCountrySnapshot?.itemIdentifiers(inSection: .main)[indexPath.row].name
                let countryCount = currentApplyObjects.filter{ $0.apply.city?.country?.name == countryName }.count
                let count = countryName == "World" ? currentApplyObjects.count : countryCount
                badgeView.configure(count: count)
            } else {
                badgeView.configure(count: 0)
            }
            return badgeView
        }
        updateCountryDataSource()
    }
    private func configureApplyDataSource(for tableView: UITableView) {
        applyDataSource = ApplyDataSource(tableView: tableView) { (tableView, indexPath, apply) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ApplyTableViewCell.reuseIdentifier, for: indexPath) as? ApplyTableViewCell else { return nil }
            cell.configure(apply: apply)
            return cell
        }
        applyDataSource.applyService = applyService
        applyDataSource.superDelegate = delegate
        applyDataSource.countryUpdater = updateCountryDataSource
        applyResultController = applyService.fetchAll()
        do {
            try applyResultController.performFetch()
            applyResultControllerDelegate = ApplyResultControllerDelegate(applyDataSource: applyDataSource)
            applyResultController.delegate = applyResultControllerDelegate
            if let objects = applyResultController.fetchedObjects {
                var snapShot = NSDiffableDataSourceSnapshot<Section, ApplyItem>()
                snapShot.appendSections([.main])
                snapShot.appendItems(objects.map{ApplyItem($0)}, toSection: .main)
                applyDataSource.apply(snapShot)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    func updateCountryDataSource() {
        let currentApplySnapshot = applyDataSource.snapshot()
        var snapShot = NSDiffableDataSourceSnapshot<Section, CountryItem>()
        countryDataSource?.apply(snapShot)
        snapShot.appendSections([.main])
        let countriesSet = Set(currentApplySnapshot.itemIdentifiers.map{$0.apply.city!.country!})
        var countries = Array(countriesSet.map{ CountryItem($0) }).sorted(by: {$0.name! < $1.name!})
        if let world = try? countryService.getWorld() {
            countries.insert(CountryItem(world), at: 0)
        }
        snapShot.appendItems(countries, toSection: .main)
        countryDataSource?.apply(snapShot)
    }
    func selectCountry(at indexPath: IndexPath) {
        guard let country = countryDataSource?.itemIdentifier(for: indexPath) else { return }
        if let objects = applyResultController.fetchedObjects {
            selectedCountry = country.country
            let filteredObjects = objects.filter { apply in
                apply.city?.country?.name == country.name
            }
            var snapShot = NSDiffableDataSourceSnapshot<Section, ApplyItem>()
            snapShot.appendSections([.main])
            snapShot.appendItems(country.name == world.name ? objects.map{ApplyItem($0)} : filteredObjects.map{ApplyItem($0)}, toSection: .main)
            if country.name == world.name {
                resetFilters()
            }
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
            var snapShot = NSDiffableDataSourceSnapshot<Section, ApplyItem>()
            snapShot.appendSections([.main])
            snapShot.appendItems(query == "" ? filteredJustByCountries.map{ApplyItem($0)} : filteredObjects.map{ApplyItem($0)}, toSection: .main)
            applyDataSource.apply(snapShot)
        }
    }
    func showApplyDetail(for indexPath: IndexPath, sender: UIViewController) {
        let apply = applyDataSource.snapshot().itemIdentifiers[indexPath.row]
        coordinator.push(scene: .apply(apply.apply), sender: sender)
    }
    func deleteApplies(indexPaths: [IndexPath]) {
        var currentSnapshot = applyDataSource.snapshot()
        let applies = currentSnapshot.itemIdentifiers.enumerated().filter { index, apply in
            indexPaths.contains { indexPath in
                indexPath.row == index
            }
        }.map { (index, apply) -> ApplyItem in
            do {
                try applyService.delete(apply: apply.apply)
            } catch {
                print(error.localizedDescription)
            }
            return apply
        }
        currentSnapshot.deleteItems(applies)
        applyDataSource.apply(currentSnapshot)
    }
    func addApply(sender: UIViewController) {
        coordinator.push(scene: .newApply(nil), sender: sender)
    }
    func filter(sender: UIViewController) {
        coordinator.present(scene: .filter(selectedCountry,applyFilter(filters:hasInterview:hasTask:isCompanyFavorite:)), sender: sender)
    }
    func applyFilter(filters:[FilterViewModel.FilterObject], hasInterview:Bool, hasTask:Bool, isCompanyFavorite: Bool) {
        let currentApplies = applyDataSource.snapshot().itemIdentifiers
        var filteredCityApplies: [ApplyItem] = []
        var filteredStateApplies: [ApplyItem] = []
        var filteredTagApplies: [ApplyItem] = []
        var filteredDateApplies: [ApplyItem] = []
        var hasSelectedCity = false
        var hasSelectedTag = false
        var hasSelectedState = false
        var hasSelectedDate = false
        
        filters.forEach { filter in
            switch filter.filterType {
            case .city:
                hasSelectedCity = true
                filteredCityApplies.append(contentsOf: currentApplies.filter({$0.apply.city == filter.city}))
            case .state:
                hasSelectedState = true
                filteredStateApplies.append(contentsOf: currentApplies.filter({$0.apply.statusEnum == filter.state}))
            case .tag:
                hasSelectedTag = true
                filteredTagApplies.append(contentsOf: currentApplies.filter({$0.apply.tag!.contains(filter.tag!)}))
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
                guard let interviews = apply.apply.interview else {return false}
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
                guard let tasks = apply.apply.task else { return false }
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
            result = result.filter({$0.apply.company?.isFavorite == true})
        }
        var snapShot = NSDiffableDataSourceSnapshot<Section,ApplyItem>()
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
            var snapShot = NSDiffableDataSourceSnapshot<Section,ApplyItem>()
            snapShot.appendSections([.main])
            snapShot.appendItems(objects.map{ApplyItem($0)}, toSection: .main)
            applyDataSource.apply(snapShot)
            onFilterChanged?(false)
        }
    }
    func start(collectionView: UICollectionView?, tableView: UITableView) {
        configureApplyDataSource(for: tableView)
        if let collectionView = collectionView {
            configureCountryDataSource(for: collectionView)
        }
    }
    // MARK: - ApplyResultControllerDelegate
    class ApplyResultControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
        let applyDataSource: UITableViewDiffableDataSource<Section, ApplyItem>
        init(applyDataSource: UITableViewDiffableDataSource<Section, ApplyItem>) {
            self.applyDataSource = applyDataSource
        }
        
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
            var diff = NSDiffableDataSourceSnapshot<Section,ApplyItem>()
            snapshot.sectionIdentifiers.forEach { _ in
                diff.appendSections([.main])
                let items = snapshot.itemIdentifiers.map { (objectId: Any) -> Apply in
                    let oid =  objectId as! NSManagedObjectID
                    return controller.managedObjectContext.object(with: oid) as! Apply
                }
                diff.appendItems(items.map{ApplyItem($0)}, toSection: .main) }
            applyDataSource.apply(diff)
        }
    }
    class ApplyDataSource: UITableViewDiffableDataSource<Section, ApplyItem> {
        var applyService: ApplyServiceType!
        var countryUpdater: (() -> Void)!
        var superDelegate: AppliesViewModelDelegate?
        override func apply(_ snapshot: NSDiffableDataSourceSnapshot<AppliesViewModel.Section, ApplyItem>, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
            super.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
            countryUpdater()
        }
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete, let apply = itemIdentifier(for: indexPath) {
                superDelegate?.deleteConfirmation { [weak self] in
                    guard let self = self else { return }
                    if $0 {
                        do {
                            try self.applyService.delete(apply: apply.apply)
                        } catch {
                            
                            self.superDelegate?.error(text: GeneralMessages.unknown.rawValue)
                        }
                    }
                }
            }
        }
    }
}
