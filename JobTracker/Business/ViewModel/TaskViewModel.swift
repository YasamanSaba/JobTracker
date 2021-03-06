//
//  TaskViewModel.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/11/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class TaskViewModel: NSObject, CoordinatorSupportedViewModel {
    
    var coordinator: CoordinatorType!
    var delegate: TaskViewModelDelegate?
    var isEditingMode: Bool = false
    private let apply: Apply
    private var task: Task? {
        didSet {
            if task != nil {
                isEditingMode = true
            }
        }
    }
    private let taskService: TaskServiceType
    private var reminderDataSource: TaskDataSource?
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
    private var selectedAssignDate: Date? {
        didSet {
            guard let selectedAssignDate = selectedAssignDate else{ return }
            let dateString = DateFormatter.localizedString(from: selectedAssignDate, dateStyle: .full, timeStyle: .none)
            delegate?.assignDate(text: dateString)
        }
    }
    private var selectedDeadline: Date? {
        didSet {
            guard let selectedDeadline = selectedDeadline else{ return }
            let dateString = DateFormatter.localizedString(from: selectedDeadline, dateStyle: .full, timeStyle: .none)
            delegate?.deadline(text: dateString)
        }
    }
    
    // MARK: Initializer
    init(apply: Apply, task: Task?,taskService: TaskServiceType, reminderService: ReminderServiceType) {
        self.apply = apply
        self.task = task
        if task != nil {
            isEditingMode = true
        }
        self.taskService = taskService
        self.reminderService = reminderService
    }
    
    // MARK: Private Functions
    private func createFirstSnapshot() {
        if isEditingMode {
            do {
                reminderResultsController = try reminderService.fetchAll(for: task!)
                reminderResultsController?.delegate = reminderDataSource
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
    private func configureReminder(tableView: UITableView) {
        reminderDataSource = TaskDataSource(tableView: tableView) {
            (tableView, indexPath, reminder) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.reuseIdentifier) as? ReminderTableViewCell, let date = reminder.date else {
                return nil
            }

            cell.configure(message: reminder.desc ?? "", date: DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .medium))
            return cell
        }
        reminderDataSource?.reminderService = reminderService
        reminderDataSource?.superDelegate = delegate
        createFirstSnapshot()
    }
    
    // MARK: Public API
    func start(tableView: UITableView) {
        configureReminder(tableView: tableView)
        if isEditingMode {
            selectedDeadline = task!.deadline!
            selectedAssignDate = task!.date!
            delegate?.title(task!.title ?? "")
            delegate?.link(task!.linkToGit?.absoluteString ?? "")
        }
    }
    func setAssign(date: Date) {
        selectedAssignDate = date
    }
    func setDeadline(date: Date) {
        selectedDeadline = date
    }
    func next(title: String, isDone: Bool, link: String?) -> Bool {
        guard let aDate = selectedAssignDate, let dDate = selectedDeadline else {
            delegate?.error(text: GeneralMessages.addEmptyItem.rawValue)
            return false
        }
        do {
            let url = link == nil ? nil : URL(string: link!)
            let task = try taskService.add(title: title, date: aDate, deadline: dDate, isDone: isDone, link: url, for: apply)
            self.task = task
            createFirstSnapshot()
            return true
        } catch _ as TaskServiceError {
            delegate?.error(text: GeneralMessages.unknown.rawValue)
        } catch {
            delegate?.error(text: GeneralMessages.unknown.rawValue)
        }
        return false
    }
    func save(title: String, isDone: Bool, link: String?) -> Bool {
        guard let task = task, let aDate = selectedAssignDate, let dDate = selectedDeadline else {
            delegate?.error(text: GeneralMessages.addEmptyItem.rawValue)
            return false
        }
        do {
            let url = link == nil ? nil : URL(string: link!)
            try taskService.update(task: task, title: title, date: aDate, deadline: dDate, isDone: isDone, link: url, for: apply)
            return true
        } catch _ as TaskServiceError {
            delegate?.error(text: GeneralMessages.unknown.rawValue)
        } catch {
            delegate?.error(text: GeneralMessages.unknown.rawValue)
        }
        return false
    }
    func addReminder(sender: UIViewController) {
        coordinator.present(scene: .reminder(task!), sender: sender)
    }
    func open(url: String) {
        if url.hasPrefix("https://") || url.hasPrefix("http://"), let myURL = URL(string: url) {
            UIApplication.shared.open(myURL)
        } else {
            let correctedURL = "http://\(url)"
            if let myURL = URL(string: correctedURL) {
                UIApplication.shared.open(myURL)
            }
        }
    }
    
    // MARK: Nested Types
    class TaskDataSource: UITableViewDiffableDataSource<Int,Reminder>, NSFetchedResultsControllerDelegate {
        var reminderService: ReminderServiceType?
        var superDelegate: TaskViewModelDelegate?
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let identifierToDelete = itemIdentifier(for: indexPath) {
                    superDelegate?.deleteConfirmation { [weak self] in
                        if $0 {
                            do {
                                try self?.reminderService?.delete(reminder: identifierToDelete)
                            } catch {
                                self?.superDelegate?.error(text: GeneralMessages.unknown.rawValue)
                            }
                        }
                    }
                }
            }
        }
        
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
            var newSnapshot = NSDiffableDataSourceSnapshot<Int,Reminder>()
            snapshot.sectionIdentifiers.forEach{ _ in
                newSnapshot.appendSections([1])
                let items = snapshot.itemIdentifiers.map { (object: Any) -> Reminder in
                    return controller.managedObjectContext.object(with: object as! NSManagedObjectID) as! Reminder
                }
                newSnapshot.appendItems(items, toSection: 1)
            }
            self.apply(newSnapshot)
        }
    }
}

