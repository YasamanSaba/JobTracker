//
//  ResumeViewModel.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/4/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class ResumeViewModel: NSObject, CoordinatorSupportedViewModel {
    
    // MARK: - Properties
    var coordinator: CoordinatorType!
    var delegate: ResumeViewModelDelegate?
    private let resumeService: ResumeServiceType
    private var resumeFetchedResultsController: NSFetchedResultsController<Resume>?
    private var resumeDataSource: ResumeDataSourece?
    private var selectedVersion: [Int] = [0,0,0]
    
    // MARK: Initializer
    init(resumeService: ResumeServiceType) {
        self.resumeService = resumeService
    }
    
    // MARK: - Private Functions
    private func configureVersion(pickerView: UIPickerView) {
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    private func configure(tableView: UITableView) {
        resumeDataSource = ResumeDataSourece(tableView: tableView) {tableView,indexPath,resume -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ResumeTableViewCell.reuseIdentifier) as? ResumeTableViewCell else { return nil }
            
            cell.configure(version: resume.version ?? "Unkown" , applyCount: String(resume.apply?.count ?? 0), hasLink: resume.linkToGit != nil)
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
    
    // MARK: - Public API
    func start(tableView: UITableView, pickerView: UIPickerView) {
        configure(tableView: tableView)
        configureVersion(pickerView: pickerView)
    }
    func add(urlString: String?) {
        let versionString = selectedVersion.map{String($0)}.joined(separator: ".")
        do {
            try resumeService.add(version: versionString, url: urlString == nil ? nil : URL(string: urlString!))
        } catch ResumeServiceError.alreadyExists {
            delegate?.error(text: "This Resume already exists")
        } catch {
            delegate?.error(text: "Please try again later")
        }
    }
    func openURL(at indexPath: IndexPath) {
        if let item = resumeDataSource?.snapshot().itemIdentifiers[indexPath.row], let url = item.linkToGit {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - Nested Types
    class ResumeDataSourece: UITableViewDiffableDataSource<Int,Resume> {
        
    }
}

// MARK: - Extensions
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
