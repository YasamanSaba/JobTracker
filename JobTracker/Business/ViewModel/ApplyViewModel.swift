//
//  ApplyViewModel.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/25/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class ApplyViewModel: NSObject {
    // MARK: - Define nested types -
    struct ApplyInfo {
        let companyName: String
        let jobOfferURL: URL
        let location: String
        let timeElapsed: String
        let state: String
        let resume: String
    }
    enum Section {
        case main
    }
    // MARK: - Properties -
    private let applyService: ApplyServiceType
    private let interviewService: InterviewServiceType
    private let taskService: TaskServiceType
    private let apply: Apply
    var resumeResultController: NSFetchedResultsController<Resume>!
    var resumeResultControllerDelegate: ResumeResultControllerDelegate!
    var interviewResultController: NSFetchedResultsController<Interview>!
    var interviewDataSource: InterviewDataSource!
    var interviewResultControllerDelegate: InterviewResultControllerDelegate!
    var taskResultController: NSFetchedResultsController<Task>!
    var taskDataSource: TaskDataSource!
    var taskResultControllerDelegate: TaskResultControllerDelegate!
    weak var statePickerView: UIPickerView?
    weak var resumePickerView: UIPickerView?
    var states: [Status] = []
    // MARK: - Initializer -
    init(applyService: ApplyServiceType,interviewService: InterviewServiceType, apply: Apply, taskService: TaskServiceType) {
        self.applyService = applyService
        self.interviewService = interviewService
        self.taskService = taskService
        self.apply = apply
    }
    // MARK: - Functions -
    func configureResume(pickerView: UIPickerView) {
        pickerView.accessibilityIdentifier = "ResumePickerView"
        resumeResultController = applyService.getAllResumeVersion()
        self.resumePickerView = pickerView
        resumeResultControllerDelegate = ResumeResultControllerDelegate(resumePickerView: pickerView)
        resumeResultController.delegate = resumeResultControllerDelegate
        do {
            try resumeResultController.performFetch()
            self.resumePickerView = pickerView
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.selectRow(resumeResultController.fetchedObjects?.firstIndex(of: apply.resume!) ?? 0, inComponent: 0, animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    func configureState(pickerView: UIPickerView) {
        self.states = applyService.getAllState()
        self.statePickerView = pickerView
        pickerView.accessibilityIdentifier = "StatePickerView"
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(states.firstIndex(of: apply.statusEnum ?? Status.hr) ?? 0, inComponent: 0, animated: true)
    }
    func getApplyInfo() -> ApplyInfo {
        var components: DateComponents? = nil
        if let appliedTime = apply.date {
            let calendar = Calendar.current
            components = calendar.dateComponents([.day], from: appliedTime, to: Date())
        }
        
        return ApplyInfo(companyName: apply.company?.title ?? "Unknown", jobOfferURL: apply.jobLink ?? URL(string: "www.google.com")!, location: "\(apply.city?.country?.name ?? "Unknown"), \(apply.city?.name ?? "Unknown")", timeElapsed: "\(components?.day ?? 0 == 0 ? "TODAY" : "\(components!.day!) days ago")" ,state: apply.statusEnum?.rawValue ?? "Unknown", resume: apply.resume?.version ?? "Unknown")
    }
    func changeState() -> String {
        if let statePickerView = statePickerView {
            let selectedRow = statePickerView.selectedRow(inComponent: 0)
            do {
                try applyService.save(apply: apply, state: states[selectedRow])
                return states[selectedRow].rawValue
            } catch {
                print(error)
            }
        }
        return ""
    }
    func changeResumeVersion() -> String {
        if let resumePickerView = resumePickerView {
            let selectedRow = resumePickerView.selectedRow(inComponent: 0)
            do {
                let resume = resumeResultController.object(at: IndexPath(row: selectedRow, section: 0))
                try applyService.save(apply: apply, resume: resume)
                return resume.version ?? ""
            } catch {
                print(error)
            }
        }
        return ""
    }
    func configureInterviewDataSource(for tableView: UITableView) {
        interviewDataSource = InterviewDataSource(tableView: tableView) { (tableView, indexPath, interview) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InterviewTableViewCell.reuseIdentifier, for: indexPath) as? InterviewTableViewCell else { return nil }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: Date(), to: interview.date!)
            var date = dateFormatter.string(from: interview.date!)
            if let days = components.day, days >= 0 {
                if days == 0 {
                    date = date + " (TODAY)"
                } else {
                    date = date + " (\(days) days left)"
                }
            }
            cell.configure(role: interview.interviewerRoleEnum?.rawValue ?? "Unknown", date: date)
            return cell
        }
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
    func configureTaskDataSource(for tableView: UITableView) {
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
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete, let interview = itemIdentifier(for: indexPath) {
                do {
                    try interviewService.delete(interview: interview)
                    var snapShot = self.snapshot()
                    snapShot.deleteItems([interview])
                    self.apply(snapShot)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    class TaskDataSource: UITableViewDiffableDataSource<Section, Task> {
        var taskService: TaskServiceType!
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete, let task = itemIdentifier(for: indexPath) {
                do {
                    try taskService.delete(task: task)
                    var snapShot = self.snapshot()
                    snapShot.deleteItems([task])
                    self.apply(snapShot)
                } catch {
                    print(error.localizedDescription)
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
        self.resumePickerView?.reloadAllComponents()
    }
}
