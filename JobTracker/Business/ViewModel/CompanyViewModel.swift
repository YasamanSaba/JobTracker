//
//  CompanyViewModel.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/30/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class CompanyViewModel: NSObject, CoordinatorSupportedViewModel {
    // MARK: - NestedType -
    class CompanyDataSource: UITableViewDiffableDataSource<Int, Company> {
        var companyService: CompanyServiceType?
        var superDelegate: CompanyViewModelDelegate?
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            true
        }
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete, let company = itemIdentifier(for: indexPath) {
                do {
                    try companyService?.delete(company: company)
                } catch CompanyServiceError.companyHasRelation {
                    superDelegate?.error(text: "You have apply in this company")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    // MARK: - Properties -
    weak var delegate: CompanyViewModelDelegate?
    var coordinator: CoordinatorType!
    let companyService: CompanyServiceType
    let onComplete: (Company) -> Void
    var companyResultsController: NSFetchedResultsController<Company>!
    var companyDataSource: CompanyDataSource!
    // MARK: - Initializer
    init(companyService: CompanyServiceType, onComplete: @escaping (Company) -> Void) {
        self.companyService = companyService
        self.onComplete = onComplete
    }
    // MARK: - Functions
    private func configureCompany(tableView: UITableView) {
        companyDataSource = CompanyDataSource(tableView: tableView) { (tableView, indexPath, company) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CompanyTableViewCell.reuseIdentifier) as? CompanyTableViewCell else {
                return nil
            }
            cell.configure(name: company.title ?? "Unknown", numberOfApplies: company.apply?.count ?? 0, isFavorite: company.isFavorite)
            return cell
        }
        companyDataSource.companyService = companyService
        companyDataSource.superDelegate = delegate
        companyResultsController = companyService.getAll()
        do {
            try companyResultsController.performFetch()
            companyResultsController.delegate = self
            if let objects = companyResultsController.fetchedObjects {
                var snapShot = NSDiffableDataSourceSnapshot<Int,Company>()
                snapShot.appendSections([1])
                snapShot.appendItems(objects, toSection: 1)
                companyDataSource.apply(snapShot)
            }
        } catch {
            print(error)
        }
    }
    func filterCompanies(by text: String) {
        if let objects = companyResultsController.fetchedObjects {
            var snapShot = NSDiffableDataSourceSnapshot<Int,Company>()
            let filteredObjects = objects.filter{ $0.title?.lowercased().contains(text.lowercased()) ?? false}
            snapShot.appendSections([1])
            snapShot.appendItems(text == "" ? objects : filteredObjects, toSection: 1)
            companyDataSource.apply(snapShot)
        }
    }
    func select(at indexPath: IndexPath) {
        let company = companyDataSource.snapshot().itemIdentifiers[indexPath.row]
        onComplete(company)
    }
    func add(name: String, isFavorite: Bool) {
        guard !name.isEmpty, !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            delegate?.error(text: "Company name cannot be empty")
            return
        }
        do {
            try companyService.add(name: name, isFavorite: isFavorite)
        } catch let error as CompanyServiceError {
            switch error {
            case .alreadyExists:
                delegate?.error(text: "Company name already exists")
                return
            case .addError:
                delegate?.error(text: "Try again later")
                return
            default:
                delegate?.error(text: "Try again later")
                return
            }
            
        } catch {
            delegate?.error(text: "Try again later")
            return
        }
    }
    func start(tableView: UITableView) {
        configureCompany(tableView: tableView)
    }
}
// MARK: - Extension
extension CompanyViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var newSnapShot = NSDiffableDataSourceSnapshot<Int,Company>()
        snapshot.sectionIdentifiers.forEach { section in
            newSnapShot.appendSections([1])
            let items = snapshot.itemIdentifiersInSection(withIdentifier: section).map{ (objectId: Any) -> Company in
                let oid =  objectId as! NSManagedObjectID
                return controller.managedObjectContext.object(with: oid) as! Company
            }
            newSnapShot.appendItems(items, toSection: 1)
        }
        companyDataSource.apply(newSnapShot)
    }
}
