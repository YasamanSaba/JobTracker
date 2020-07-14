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
    private var isEditingMode: Bool = false
    private let apply: Apply
    private let task: Task?
    private var reminderDataSource: UITableViewDiffableDataSource<Int,Reminder>?
    private var reminderResultsController: NSFetchedResultsController<Reminder>?
    private let reminderService: ReminderServiceType
    private var reminders: [Reminder] = [] {
        didSet {
            var snapShot = NSDiffableDataSourceSnapshot<Int,Reminder>()
            snapShot.appendSections([1])
            snapShot.appendItems(reminders, toSection: 1)
            reminderDataSource?.apply(snapShot)
        }
    }
    private var assignDateTextSetter: ((String) -> Void)?
    private var deadlineTextSetter: ((String) -> Void)?
    private var selectedAssignDate: Date? {
        didSet {
            guard let selectedAssignDate = selectedAssignDate else{ return }
            let dateString = DateFormatter.localizedString(from: selectedAssignDate, dateStyle: .full, timeStyle: .none)
            assignDateTextSetter?(dateString)
        }
    }
    private var selectedDeadline: Date? {
        didSet {
            guard let selectedDeadline = selectedDeadline else{ return }
            let dateString = DateFormatter.localizedString(from: selectedDeadline, dateStyle: .full, timeStyle: .none)
            deadlineTextSetter?(dateString)
        }
    }
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
    func assignDateText(setter: @escaping (String) -> Void) {
        assignDateTextSetter = setter
        if isEditingMode {
            selectedAssignDate = task!.date!
        }
    }
    func deadlineText(setter: @escaping (String) -> Void) {
        deadlineTextSetter = setter
        if isEditingMode {
            selectedDeadline = task!.deadline!
        }
    }
    func setAssign(date: Date) {
        selectedAssignDate = date
    }
    func setDeadline(date: Date) {
        selectedDeadline = date
    }
}

extension TaskViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var newSnapshot = NSDiffableDataSourceSnapshot<Int,Reminder>()
        snapshot.sectionIdentifiers.forEach{ _ in
            newSnapshot.appendSections([1])
            let items = snapshot.itemIdentifiers.map { (object: Any) -> Reminder in
                return controller.managedObjectContext.object(with: object as! NSManagedObjectID) as! Reminder
            }
            newSnapshot.appendItems(items, toSection: 1)
        }
        reminderDataSource?.apply(newSnapshot)
    }
}
