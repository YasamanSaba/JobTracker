//
//  TaskViewModel.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/11/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class TaskViewModel: NSObject {
    var isEditingMode: Bool = false
    let apply: Apply
    let task: Task?
    var reminderDataSource: UITableViewDiffableDataSource<Int,Reminder>?
    var reminderResultsController: NSFetchedResultsController<Reminder>?
    let reminderService: ReminderServiceType
    
    init(apply: Apply, task: Task?, reminderService: ReminderServiceType) {
        self.apply = apply
        self.task = task
        self.reminderService = reminderService
        if let task =  task {
            self.isEditingMode = true
            print(task)
        }
    }
    
    func configureReminder(tableView: UITableView) {
        reminderDataSource = UITableViewDiffableDataSource<Int,Reminder>(tableView: tableView) {
            (tableView, indexPath, reminder) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.reuseIdentifier) as? ReminderTableViewCell, let date = reminder.date else {return nil}

            cell.configure(message: reminder.desc ?? "", date: DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .medium))
            return cell
        }
        if isEditingMode {
            do {
                reminderResultsController = try reminderService.fetchAll(for: task!)
                reminderResultsController?.delegate = self
                try reminderResultsController?.performFetch()
                if let objects = reminderResultsController?.fetchedObjects {
                    var snapShot = NSDiffableDataSourceSnapshot<Int,Reminder>()
                    snapShot.appendSections([1])
                    snapShot.appendItems(objects, toSection: 1)
                    reminderDataSource?.apply(snapShot)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    func getCurrentTitleAndURL() -> (String?,String?) {
        return (task?.title , task?.linkToGit?.absoluteString)
    }
    
}

extension TaskViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
         
    }
}
