//
//  ApplyViewModel.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/25/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class ApplyViewModel: NSObject, CoordinatorSupportedViewModel {
    // MARK: - Define nested types -
    struct ApplyInfo {
        let companyName: String
        let jobOfferURL: URL
        let location: String
        let timeElapsed: String
        let state: String
        let resume: String
        let isFavorite: Bool
    }
    enum Section {
        case main
    }
    // MARK: - Properties -
    weak var delegate: ApplyViewModelDelegate?
    var coordinator: CoordinatorType!
    private let applyService: ApplyServiceType
    private let stateService: StateServiceType
    private let interviewService: InterviewServiceType
    private let taskService: TaskServiceType
    private let companyService: CompanyServiceType
    private let tagService: TagServiceType
    private let reminderService: ReminderService
    private let apply: Apply
    var applyResultController: NSFetchedResultsController<Apply>!
    var resumeResultController: NSFetchedResultsController<Resume>!
    var resumeResultControllerDelegate: ResumeResultControllerDelegate!
    var interviewResultController: NSFetchedResultsController<Interview>!
    var interviewDataSource: InterviewDataSource!
    var interviewResultControllerDelegate: InterviewResultControllerDelegate!
    var taskResultController: NSFetchedResultsController<Task>!
    var taskDataSource: TaskDataSource!
    var taskResultControllerDelegate: TaskResultControllerDelegate!
    var tagDataSource: UICollectionViewDiffableDataSource<Section, Tag>!
    var tagResultController: NSFetchedResultsController<Tag>!
    weak var statePickerView: UIPickerView?
    weak var resumePickerView: UIPickerView?
    var states: [Status] = []
    // MARK: - Initializer -
    init(applyService: ApplyServiceType,interviewService: InterviewServiceType, apply: Apply, taskService: TaskServiceType, companyService: CompanyServiceType, stateService: StateServiceType, tagService: TagServiceType, reminderService: ReminderService) {
        self.applyService = applyService
        self.interviewService = interviewService
        self.taskService = taskService
        self.apply = apply
        self.companyService = companyService
        self.stateService = stateService
        self.tagService = tagService
        self.reminderService = reminderService
    }
    // MARK: - Functions -
    func start(collectionView: UICollectionView, interviewTableView: UITableView?, taskTableview: UITableView?) {
        let info = ApplyInfo(companyName: apply.company?.title ?? "Unknown", jobOfferURL: apply.jobLink ?? URL(string: "www.google.com")!, location: "\(apply.city?.country?.name ?? "Unknown"), \(apply.city?.name ?? "Unknown")", timeElapsed: MyDateFormatter.shared.passedTime(from: apply.date!) ,state: apply.statusEnum?.rawValue ?? "Unknown", resume: apply.resume?.version ?? "Unknown", isFavorite: apply.company?.isFavorite ?? false)
        delegate?.applyInfo(info)
        applyResultController = applyService.fetch(apply: apply)
        try? applyResultController.performFetch()
        applyResultController.delegate = self
        // MARK: Call private functions
        configureTag(collectionView: collectionView)
        if let interviewTableView = interviewTableView {
            configureInterviewDataSource(for: interviewTableView)
        }
        if let taskTableview = taskTableview {
            configureTaskDataSource(for: taskTableview)
        }
    }
    private func configureTag(collectionView: UICollectionView) {
        tagDataSource = UICollectionViewDiffableDataSource<Section,Tag>(collectionView: collectionView) { (collectionView, indexPath, tag) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.reuseIdentifier, for: indexPath) as? TagCollectionViewCell else {return nil}
            cell.configure(tag: tag)
            return cell
        }
        if let tagSet = apply.tag {
            var snapShot = NSDiffableDataSourceSnapshot<Section,Tag>()
            snapShot.appendSections([.main])
            snapShot.appendItems(Array(tagSet.map{$0 as! Tag}), toSection: .main)
            tagDataSource.apply(snapShot)
        }
    }
    private func configureInterviewDataSource(for tableView: UITableView) {
        interviewDataSource = InterviewDataSource(tableView: tableView) { (tableView, indexPath, interview) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InterviewTableViewCell.reuseIdentifier, for: indexPath) as? InterviewTableViewCell else { return nil }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var date = dateFormatter.string(from: interview.date!)
            date = date + " " + MyDateFormatter.shared.remainTime(to: interview.date!)
            cell.configure(role: interview.interviewerRoleEnum?.rawValue ?? "Unknown", date: date)
            return cell
        }
        interviewDataSource.superDelegate = delegate
        interviewDataSource.reminderService = reminderService
        interviewDataSource.interviewService = interviewService
        interviewResultController = interviewService.fetch(apply: apply)
        do {
            try interviewResultController.performFetch()
            interviewResultControllerDelegate = InterviewResultControllerDelegate(interviewDataSource: interviewDataSource)
            interviewResultController.delegate = interviewResultControllerDelegate
            if let objects = interviewResultController.fetchedObjects {
                var snapShot = NSDiffableDataSourceSnapshot<Section, Interview>()
                snapShot.appendSections([.main])
                snapShot.appendItems(objects, toSection: .main)
                interviewDataSource.apply(snapShot, animatingDifferences: false)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    private func configureTaskDataSource(for tableView: UITableView) {
        taskDataSource = TaskDataSource(tableView: tableView) { (tableView, indexPath, task) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as? TaskTableViewCell else {return nil}
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: Date(), to: task.deadline!)
            var date = dateFormatter.string(from: task.date!)
            if let days = components.day, days >= 0 {
                if days == 0 {
                    date = date + " (TODAY)"
                } else {
                    date = date + " (\(days) days left)"
                }
            }
            cell.configure(title: task.title ?? "Unknown", deadLine: date)
            return cell
        }
        taskDataSource.superDelegate = delegate
        taskDataSource.reminderService = reminderService
        taskDataSource.taskService = taskService
        taskResultController = taskService.fetch(apply: apply)
        do {
            try taskResultController.performFetch()
            taskResultControllerDelegate = TaskResultControllerDelegate(taskDataSource: taskDataSource)
            taskResultController.delegate = taskResultControllerDelegate
            if let objects = taskResultController.fetchedObjects {
                var snapShot = NSDiffableDataSourceSnapshot<Section, Task>()
                snapShot.appendSections([.main])
                snapShot.appendItems(objects, toSection: .main)
                taskDataSource.apply(snapShot, animatingDifferences: false)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    func checklist(sender: UIViewController) {
        coordinator.present(scene: .checklist(apply), sender: sender)
    }
    func editApply(sender: UIViewController) {
        coordinator.push(scene: .newApply(apply), sender: sender)
    }
    func addTags(sender: UIViewController) {
        coordinator.present(scene: .tag({ [weak self] tags in
            guard let self = self else {return}
            try? self.applyService.deleteTags(from: self.apply)
            try? self.applyService.add(tags: tags, to: self.apply)
            if let tagSet = self.apply.tag {
                var snapShot = NSDiffableDataSourceSnapshot<Section,Tag>()
                snapShot.appendSections([.main])
                snapShot.appendItems(Array(tagSet.map{$0 as! Tag}), toSection: .main)
                self.tagDataSource.apply(snapShot)
            }
            }, apply.tag == nil ? [] : Array(apply.tag!.map{$0 as! Tag})), sender: sender)
    }
    func addTask(sender: Any) {
        coordinator.push(scene: .task(apply,nil), sender: sender)
    }
    func setIsFavorite(_ value: Bool) {
        try? companyService.setIsFavorite(for: apply, value)
    }
    func addInterview(sender: UIViewController) {
        coordinator.push(scene: .interview(apply,nil), sender: sender)
    }
    func selectInterview(at indexPath: IndexPath, sender: UIViewController) {
        let interview = interviewDataSource.snapshot().itemIdentifiers[indexPath.row]
        coordinator.push(scene: .interview(apply, interview), sender: sender)
    }
    func selectTask(at indexPath: IndexPath, sender: UIViewController) {
        let task = taskDataSource.snapshot().itemIdentifiers[indexPath.row]
        coordinator.push(scene: .task(apply,task), sender: sender)
    }
    func openResumeLink() {
        if let url = apply.resume?.linkToGit?.absoluteString {
            if url.hasPrefix("https://") || url.hasPrefix("http://"), let myURL = URL(string: url) {
                UIApplication.shared.open(myURL)
            } else {
                let correctedURL = "http://\(url)"
                if let myURL = URL(string: correctedURL) {
                    UIApplication.shared.open(myURL)
                }
            }
        }
    }
    func openApplyLink() {
        if let url = apply.jobLink?.absoluteString {
            if url.hasPrefix("https://") || url.hasPrefix("http://"), let myURL = URL(string: url) {
                UIApplication.shared.open(myURL)
            } else {
                let correctedURL = "http://\(url)"
                if let myURL = URL(string: correctedURL) {
                    UIApplication.shared.open(myURL)
                }
            }
        }
    }
    // MARK: - InterviewResultControllerDelegate
    class InterviewResultControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
        // MARK: - Property
        let interviewDataSource: UITableViewDiffableDataSource<Section, Interview>
        // MARK: - Initializer
        init(interviewDataSource: UITableViewDiffableDataSource<Section, Interview>) {
            self.interviewDataSource = interviewDataSource
        }
        // MARK: - Function
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
            var diff = NSDiffableDataSourceSnapshot<Section,Interview>()
            snapshot.sectionIdentifiers.forEach { _ in
                diff.appendSections([.main])
                let items = snapshot.itemIdentifiers.map { (objectId: Any) -> Interview in
                    let oid =  objectId as! NSManagedObjectID
                    return controller.managedObjectContext.object(with: oid) as! Interview
                }
                diff.appendItems(items, toSection: .main) }
            interviewDataSource.apply(diff)
        }
    }
    // MARK: - ResumeResultControllerDelegate -
    class ResumeResultControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
        let resumePickerView: UIPickerView
        init(resumePickerView: UIPickerView) {
            self.resumePickerView = resumePickerView
        }
        func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            self.resumePickerView.reloadAllComponents()
        }
    }
    // MARK: - TaskResultControllerDelegate -
    class TaskResultControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
        let taskDataSource: UITableViewDiffableDataSource<Section, Task>
        init(taskDataSource: UITableViewDiffableDataSource<Section, Task>) {
            self.taskDataSource = taskDataSource
        }
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
            var diff = NSDiffableDataSourceSnapshot<Section,Task>()
            snapshot.sectionIdentifiers.forEach { _ in
                diff.appendSections([.main])
                let items = snapshot.itemIdentifiers.map { (objectId: Any) ->Task in
                    let oid = objectId as! NSManagedObjectID
                    return controller.managedObjectContext.object(with: oid) as! Task
                }
                diff.appendItems(items, toSection: .main)
            }
            taskDataSource.apply(diff)
        }
    }
    // MARK: - Override
    class InterviewDataSource: UITableViewDiffableDataSource<Section, Interview> {
        var interviewService: InterviewServiceType!
        var reminderService: ReminderServiceType!
        var superDelegate: ApplyViewModelDelegate!
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete, let interview = itemIdentifier(for: indexPath) {
                superDelegate.deleteConfirmation { [weak self] in
                    guard let self = self else { return }
                    if $0 {
                        do {
                            if let reminders = interview.reminder, reminders.count > 0 {
                                try reminders.forEach {
                                    try self.reminderService.delete(reminder: $0 as! Reminder)
                                }
                            }
                            try self.interviewService.delete(interview: interview)
                        } catch {
                            self.superDelegate.error(text: GeneralMessages.unknown.rawValue)
                        }
                    }
                }
            }
        }
    }
    class TaskDataSource: UITableViewDiffableDataSource<Section, Task> {
        var taskService: TaskServiceType!
        var reminderService: ReminderServiceType!
        var superDelegate: ApplyViewModelDelegate!
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete, let task = itemIdentifier(for: indexPath) {
                superDelegate.deleteConfirmation { [weak self] in
                    guard let self = self else { return }
                    if $0 {
                        do {
                            if let reminders = task.reminder, reminders.count > 0 {
                                try reminders.forEach {
                                    try self.reminderService.delete(reminder: $0 as! Reminder)
                                }
                            }
                            try self.taskService.delete(task: task)
                        } catch {
                            self.superDelegate.error(text: GeneralMessages.unknown.rawValue)
                        }
                    }
                }
            }
        }
    }
}
// MARK: - Extensions -
extension ApplyViewModel: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.accessibilityIdentifier == "ResumePickerView", let objects = resumeResultController.fetchedObjects {
            return objects.count
        }
        if pickerView.accessibilityIdentifier == "StatePickerView" {
            return self.states.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.accessibilityIdentifier == "ResumePickerView", let objects = resumeResultController.fetchedObjects {
            return objects[row].version ?? ""
        }
        if pickerView.accessibilityIdentifier == "StatePickerView" {
            return self.states[row].rawValue
        }
        return ""
    }
}
extension ApplyViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let info = ApplyInfo(companyName: apply.company?.title ?? "Unknown", jobOfferURL: apply.jobLink ?? URL(string: "www.google.com")!, location: "\(apply.city?.country?.name ?? "Unknown"), \(apply.city?.name ?? "Unknown")", timeElapsed: MyDateFormatter.shared.passedTime(from: apply.date!) ,state: apply.statusEnum?.rawValue ?? "Unknown", resume: apply.resume?.version ?? "Unknown", isFavorite: apply.company?.isFavorite ?? false)
        delegate?.applyInfo(info)
    }
}
