//
//  CompanyViewModel.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/30/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

enum CompanyViewModelError:String, Error {
    case companyAlreadyExists = "Company with same name already exists."
    case addError = "Can not add. please try again later."
    case unKnownError = "Please try again later."
}

class CompanyViewModel: NSObject {
    
    let companyService: CompanyServiceType
    let onComplete: (Company) -> Void
    var companyResultsController: NSFetchedResultsController<Company>!
    var companyDataSource: UITableViewDiffableDataSource<Int,Company>!
    
    init(companyService: CompanyServiceType, onComplete: @escaping (Company) -> Void) {
        self.companyService = companyService
        self.onComplete = onComplete
    }
    
    func configureCompany(tableView: UITableView) {
        companyDataSource = UITableViewDiffableDataSource<Int,Company>(tableView: tableView) { (tableView, indexPath, company) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CompanyTableViewCell.reuseIdentifier) as? CompanyTableViewCell else {
                return nil
            }
            cell.configure(name: company.title ?? "Unknown", numberOfApplies: company.apply?.count ?? 0)
            return cell
        }
        
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
    
    func delete(at indexPath: IndexPath) {
        
    }
    
    func add(name: String) throws {
        do {
            try companyService.add(name: name)
        } catch let error as CompanyServiceError {
            switch error {
            case .alreadyExists:
                throw CompanyViewModelError.companyAlreadyExists
            case .addError:
                throw CompanyViewModelError.addError
            }
            
        } catch {
            throw CompanyViewModelError.unKnownError
        }
    }
}

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
