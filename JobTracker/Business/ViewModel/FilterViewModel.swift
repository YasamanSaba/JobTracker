//
//  FilterViewModel.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 7/1/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

struct FilterViewModel {
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
    var filters: [FilterObject] = []
    // MARK: - Initializer
    init(tagService: TagServiceType, cityService: CityServiceType, stateService: StateServiceType, country: Country) {
        self.tagService = tagService
        self.cityService = cityService
        self.stateService = stateService
        self.country = country
    }
    // MARK: - Functions -
    mutating func setupTagDataSource(for tableView: UITableView) {
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
    mutating func setupCityDataSource(for tableView: UITableView) {
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
    mutating func setupStateDataSource(for tableView: UITableView) {
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
    mutating func setupFilterObjectDataSource(for collectionView: UICollectionView) {
        filterObjectDataSource = UICollectionViewDiffableDataSource<Section, FilterObject>(collectionView: collectionView) { (collectionView, indexPath, filter) -> UICollectionViewCell? in
            switch filter.filterType {
            case .city:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCollectionViewCell.reuseIdentifier, for: indexPath) as? CityCollectionViewCell {
                    if let city = filter.city {
                        cell.configure(city: city)
                        return cell
                    }
                }
            case .state:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StateCollectionViewCell.reuseIdentifier, for: indexPath) as? StateCollectionViewCell {
                    if let state = filter.state {
                        cell.configure(state: state)
                        return cell
                    }
                }
            case .tag:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.reuseIdentifier, for: indexPath) as? TagCollectionViewCell {
                    if let tag = filter.tag {
                        cell.configure(tag: tag) { tag in
                            
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
    
}
