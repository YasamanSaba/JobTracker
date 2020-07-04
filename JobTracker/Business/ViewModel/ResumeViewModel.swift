//
//  ResumeViewModel.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/4/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

enum ResumeViewModelError: String, Error {
    case alreadyExists = "This Resume already exists."
    case notValidURL = "The URL is not a valid."
    case unKnownError = "Please try again later."
}

class ResumeViewModel: NSObject {
    
    let resumeService: ResumeServiceType
    var resumeFetchedResultsController: NSFetchedResultsController<Resume>?
    var resumeDataSource: ResumeDataSourece?
    var selectedVersion: [Int] = [0,0,0]
    init(resumeService: ResumeServiceType) {
        self.resumeService = resumeService
    }
    
    func configureVersion(pickerView: UIPickerView) {
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func configure(tableView: UITableView) {
        resumeDataSource = ResumeDataSourece(tableView: tableView) {tableView,indexPath,resume -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ResumeTableViewCell.reuseIdentifier) as? ResumeTableViewCell else { return nil }
            
            cell.configure(version: resume.version ?? "Unkown" , applyCount: String(resume.apply?.count ?? 0))
            return cell
        }
        resumeFetchedResultsController = resumeService.getAll()
        resumeFetchedResultsController?.delegate = self
        do {
            try resumeFetchedResultsController?.performFetch()
            if let objects = resumeFetchedResultsController?.fetchedObjects {
                var snapShot = NSDiffableDataSourceSnapshot<Int,Resume>()
                snapShot.appendSections([1])
                snapShot.appendItems(objects, toSection: 1)
                resumeDataSource?.apply(snapShot)
            }
        } catch {
            print(error)
        }
    }
    
    func add(urlString: String) throws {
        guard let validURL = URL(string: urlString) else { throw ResumeViewModelError.notValidURL}
        let versionString = selectedVersion.map{String($0)}.joined(separator: ".")
        do {
            try resumeService.add(version: versionString, url: validURL)
        } catch ResumeServiceError.alreadyExists {
            throw ResumeViewModelError.alreadyExists
        } catch {
            throw ResumeViewModelError.unKnownError
        }
    }
    
    class ResumeDataSourece: UITableViewDiffableDataSource<Int,Resume> {
        
    }
}

extension ResumeViewModel: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        50
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        String(row)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedVersion[component] = row
    }
    
}

extension ResumeViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var newSnapShot = NSDiffableDataSourceSnapshot<Int,Resume>()
        snapshot.sectionIdentifiers.forEach { section in
            newSnapShot.appendSections([1])
            let items = snapshot.itemIdentifiersInSection(withIdentifier: section).map{ (objectId: Any) -> Resume in
                let oid =  objectId as! NSManagedObjectID
                return controller.managedObjectContext.object(with: oid) as! Resume
            }
            newSnapShot.appendItems(items, toSection: 1)
        }
        resumeDataSource?.apply(newSnapShot)
    }
}
