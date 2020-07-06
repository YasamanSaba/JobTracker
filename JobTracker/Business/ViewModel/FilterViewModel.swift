//
//  FilterViewModel.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 7/1/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class FilterViewModel {
    // MARK: - Nested Types -
    enum Section {
        case main
    }
    struct FilterObject: Hashable {
        enum FilterType {
            case city
            case tag
            case state
        }
        let filterType: FilterType
        var city: City?
        var tag: Tag?
        var state: Status?
    }
    // MARK: - Properties -
    let tagService: TagServiceType
    var tagDataSource: UITableViewDiffableDataSource<Section, Tag>?
    var tagResultController: NSFetchedResultsController<Tag>?
    let cityService: CityServiceType
    var cityDataSource: UITableViewDiffableDataSource<Section, City>?
    var cityResultController: NSFetchedResultsController<City>?
    let stateService: StateServiceType
    var stateDataSource: UITableViewDiffableDataSource<Section, Status>?
    let country: Country
    var states: [Status] = []
    var filterObjectDataSource: UICollectionViewDiffableDataSource<Section, FilterObject>?
    var filters: [FilterObject] = [] {
        didSet {
            var snapShot = NSDiffableDataSourceSnapshot<Section, FilterObject>()
            snapShot.appendSections([.main])
            snapShot.appendItems(filters, toSection: .main)
            filterObjectDataSource?.apply(snapShot)
        }
    }
    var hasFutureInterview: Bool = false
    var hasTask: Bool = false
    var isCompanyFavorite: Bool = false
    let onCompletion: ([FilterObject], Bool, Bool, Bool) -> Void
    // MARK: - Initializer
    init(tagService: TagServiceType, cityService: CityServiceType, stateService: StateServiceType, country: Country, onCompletion: @escaping ([FilterObject], Bool, Bool, Bool) -> Void) {
        self.tagService = tagService
        self.cityService = cityService
        self.stateService = stateService
        self.country = country
        self.onCompletion = onCompletion
    }
    // MARK: - Functions -
    func setupTagDataSource(for tableView: UITableView) {
        tagDataSource = UITableViewDiffableDataSource<Section, Tag>(tableView: tableView) { (tableView, indexPath, tag) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath)
            cell.textLabel?.text = tag.title
            return cell
        }
        tagResultController = tagService.fetchAll()
        if let tagResultController = tagResultController {
            do {
                try tagResultController.performFetch()
                if let objects = tagResultController.fetchedObjects {
                    var snapShot = NSDiffableDataSourceSnapshot<Section, Tag>()
                    snapShot.appendSections([.main])
                    snapShot.appendItems(objects, toSection: .main)
                    tagDataSource?.apply(snapShot, animatingDifferences: false)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    func setupCityDataSource(for tableView: UITableView) {
        cityDataSource = UITableViewDiffableDataSource<Section, City>(tableView:  tableView) { (tableView, indexPath, city) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
            cell.textLabel?.text = city.name
            return cell
        }
        if country.name == "World" {
            cityResultController = cityService.fetchAll()
        } else {
            cityResultController = cityService.fetchAll(in: country)
        }
        if let cityResultController = cityResultController {
            do {
                try cityResultController.performFetch()
                if let objects = cityResultController.fetchedObjects {
                    var snapShot = NSDiffableDataSourceSnapshot<Section, City>()
                    snapShot.appendSections([.main])
                    snapShot.appendItems(objects, toSection: .main)
                    cityDataSource?.apply(snapShot, animatingDifferences: false)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    func setupStateDataSource(for tableView: UITableView) {
        stateDataSource = UITableViewDiffableDataSource<Section, Status>(tableView: tableView) { (tableView, indexPath, state) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "StateCell", for: indexPath)
            cell.textLabel?.text = state.rawValue
            return cell
        }
        states = stateService.getAllState()
        var snapShot = NSDiffableDataSourceSnapshot<Section, Status>()
        snapShot.appendSections([.main])
        snapShot.appendItems(states, toSection: .main)
        stateDataSource?.apply(snapShot, animatingDifferences: false)
    }
    func setupFilterObjectDataSource(for collectionView: UICollectionView) {
        filterObjectDataSource = UICollectionViewDiffableDataSource<Section, FilterObject>(collectionView: collectionView) { (collectionView, indexPath, filter) -> UICollectionViewCell? in
            switch filter.filterType {
            case .city:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCollectionViewCell.reuseIdentifier, for: indexPath) as? CityCollectionViewCell {
                    if let city = filter.city {
                        cell.configure(city: city) { [weak self] city in
                            if let items = self?.filters.filter({ $0.city?.name == city.name }), items.count == 1, let index = self?.filters.firstIndex(of: items.first!) {
                                self?.filters.remove(at: index)
                            }
                        }
                        return cell
                    }
                }
            case .state:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StateCollectionViewCell.reuseIdentifier, for: indexPath) as? StateCollectionViewCell {
                    if let state = filter.state {
                        cell.configure(state: state) { [weak self] state in
                            if let items = self?.filters.filter ({ $0.state?.rawValue == state.rawValue}), items.count == 1, let index = self?.filters.firstIndex(of: items.first!) {
                                self?.filters.remove(at: index)
                            }
                        }
                        return cell
                    }
                }
            case .tag:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.reuseIdentifier, for: indexPath) as? TagCollectionViewCell {
                    if let tag = filter.tag {
                        cell.configure(tag: tag) { [weak self] tag in
                            if let items = self?.filters.filter({$0.tag?.title == tag.title}), items.count == 1, let index = self?.filters.firstIndex(of: items.first!) {
                                self?.filters.remove(at: index)
                            }
                        }
                        return cell
                    }
                }
            }
            return nil
        }
    }
    func filterCity(for query: String) {
        if let objects = cityResultController?.fetchedObjects {
            let filteredObjects = objects.filter {
                $0.name?.lowercased().contains(query.lowercased()) ?? false
            }
            var snapShot = NSDiffableDataSourceSnapshot<Section,City>()
            snapShot.appendSections([.main])
            snapShot.appendItems(query == "" ? objects :filteredObjects, toSection: .main)
            cityDataSource?.apply(snapShot)
        }
    }
    func filterTag(for query: String) {
        if let objects = tagResultController?.fetchedObjects {
            let filteredObjects = objects.filter {
                $0.title?.lowercased().contains(query.lowercased()) ?? false
            }
            var snapShot = NSDiffableDataSourceSnapshot<Section, Tag>()
            snapShot.appendSections([.main])
            snapShot.appendItems(query == "" ? objects : filteredObjects, toSection: .main)
            tagDataSource?.apply(snapShot)
        }
    }
    func filterState(for query: String) {
        var objects: [Status] = []
        if query != "" {
            objects = states.filter{$0.rawValue.lowercased().contains(query.lowercased())}
        } else {
            objects = states
        }
        var snapShot = NSDiffableDataSourceSnapshot<Section, Status>()
        snapShot.appendSections([.main])
        snapShot.appendItems(objects, toSection: .main)
        stateDataSource?.apply(snapShot)
    }
    func addCity(at indexPath: IndexPath) {
        if let currentSnapshot = cityDataSource?.snapshot() {
            let city = currentSnapshot.itemIdentifiers[indexPath.row]
            let result = filters.contains{ $0.city == city}
            if !result {
                let filterCityObject = FilterObject(filterType: .city, city: city, tag: nil, state: nil)
                filters.append(filterCityObject)
            }
        }
    }
    func addTag(at indexPath: IndexPath) {
        if let currentSnapshot = tagDataSource?.snapshot() {
            let tag = currentSnapshot.itemIdentifiers[indexPath.row]
            let result = filters.contains { $0.tag == tag }
            if !result {
                let filterTagObject = FilterObject(filterType: .tag, city: nil, tag: tag, state: nil)
                filters.append(filterTagObject)
            }
        }
    }
    func addState(at indexPath: IndexPath) {
        if let currentSnapshot = stateDataSource?.snapshot() {
            let state = currentSnapshot.itemIdentifiers[indexPath.row]
            let result = filters.contains { $0.state == state }
            if !result {
                let filterStateObject = FilterObject(filterType: .state, city: nil, tag: nil, state: state)
                filters.append(filterStateObject)
            }
        }
    }
    func set(futureInterview: Bool) {
        hasFutureInterview = futureInterview
    }
    func set(task: Bool) {
        hasTask = task
    }
    func set(companyFavorite: Bool) {
        isCompanyFavorite = companyFavorite
    }
    func done() {
        onCompletion(filters, hasFutureInterview, hasTask, isCompanyFavorite)
    }
}
