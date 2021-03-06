//
//  InterviewViewModel.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 7/11/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class InterviewViewModel: NSObject, CoordinatorSupportedViewModel {
    
    // MARK: - Nested types
    class ReminderDataSource: UITableViewDiffableDataSource<Int, Reminder>, NSFetchedResultsControllerDelegate {
        var reminderService: ReminderServiceType?
        var superDelegate: InterviewViewModelDelegate?
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
            var newSnapshot = NSDiffableDataSourceSnapshot<Int, Reminder>()
            snapshot.sectionIdentifiers.forEach { _ in
                newSnapshot.appendSections([1])
                let items = snapshot.itemIdentifiers.map { (objectId: Any) -> Reminder in
                    controller.managedObjectContext.object(with: objectId as! NSManagedObjectID) as! Reminder
                }
                newSnapshot.appendItems(items, toSection: 1)
            }
            self.apply(newSnapshot)
        }
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            true
        }
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let reminder = itemIdentifier(for: indexPath) {
                    superDelegate?.deleteConfirmation { [weak self] in
                        if $0 {
                            try? self?.reminderService?.delete(reminder: reminder)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Public Properties
    var coordinator: CoordinatorType!
    var delegate: InterviewViewModelDelegate?
    var isEditingMode: Bool = false
    
    // MARK: - Private Properties
    private var interviewDate: Date? {
        didSet {
            guard let interviewDate = interviewDate else {return}
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mm a"
            delegate?.date(text: dateFormatter.string(from: interviewDate))
        }
    }
    private let apply: Apply
    private var interview: Interview? {
        didSet {
            if interview != nil {
                isEditingMode = true
            }
        }
    }
    private let interviewService: InterviewServiceType
    private let tagService: TagServiceType
    private let reminderService: ReminderServiceType
    private var selectedRole: InterviewerRole? {
        didSet {
            guard let selectedRole = selectedRole else {return}
            delegate?.role(text: selectedRole.rawValue)
        }
    }
    private var roles: [InterviewerRole] = []
    private var selectedTags: [Tag] = [] {
        didSet {
            var snapShot = NSDiffableDataSourceSnapshot<Int,Tag>()
            snapShot.appendSections([1])
            snapShot.appendItems(selectedTags)
            tagDatasource.apply(snapShot)
        }
    }
    private var tagDatasource: UICollectionViewDiffableDataSource<Int,Tag>!
    private var reminderDataSource: ReminderDataSource!
    private var reminderResultsController: NSFetchedResultsController<Reminder>!
    
    // MARK: - Initializer
    init(interviewService: InterviewServiceType, tagService: TagServiceType, interview: Interview?, reminderService: ReminderServiceType, apply: Apply) {
        self.apply = apply
        self.interviewService = interviewService
        self.tagService = tagService
        self.interview = interview
        self.reminderService = reminderService
        if interview != nil {
            isEditingMode = true
        }
    }
    // MARK: - Private Functions
    private func configureRole(pickerView: UIPickerView) {
        roles = interviewService.getAllRoles()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    private func configureTags(collectionView: UICollectionView) {
        tagDatasource = UICollectionViewDiffableDataSource<Int,Tag>(collectionView: collectionView) { (collectionView, indexPath, tag) -> UICollectionViewCell? in
            guard let cell =
                collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.reuseIdentifier, for: indexPath)
                    as? TagCollectionViewCell else {return nil}
            cell.configure(tag: tag) { [weak self] tag in
                if let index = self?.selectedTags.firstIndex(of: tag) {
                    self?.selectedTags.remove(at: index)
                }
            }
            return cell
        }
        if isEditingMode, let tags = interview!.tag {
            selectedTags = Array(tags.map{$0 as! Tag})
        }
    }
    private func reminderSnapShot() {
        if isEditingMode {
            do {
                reminderResultsController = try reminderService.fetchAll(for: interview!)
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
        reminderDataSource = ReminderDataSource(tableView: tableView) {
            (tableView, indexPath, reminder) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.reuseIdentifier) as? ReminderTableViewCell, let date = reminder.date else {return nil}
            cell.configure(message: reminder.desc ?? "", date: DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .medium))
            return cell
        }
        reminderDataSource.reminderService = reminderService
        reminderDataSource.superDelegate = delegate
        reminderSnapShot()
    }
    
    // MARK: - Public API
    func start(pickerView: UIPickerView, collectionView: UICollectionView, tableView: UITableView) {
        configureRole(pickerView: pickerView)
        configureTags(collectionView: collectionView)
        configureReminder(tableView: tableView)
        selectedRole = roles.first
        if isEditingMode {
            interviewDate = interview!.date
            selectedRole = interview!.interviewerRoleEnum
            delegate?.desc(text: interview!.desc ?? "")
            delegate?.interviewer(text: interview!.interviewers ?? "")
            delegate?.link(text: interview?.link?.absoluteString ?? "")
        }
    }
    func set(date: Date) {
        interviewDate = date
    }
    func addTags(sender: UIViewController) {
        if isEditingMode{
            coordinator.present(scene: .tag({ [weak self] tags in
                guard let self = self else { return}
                try? self.interviewService.update(interview: self.interview!, date: nil, link: nil, interviewer: nil, role: nil, desc: nil, tags: tags)
                self.selectedTags = tags
                }, tagDatasource.snapshot().itemIdentifiers), sender: sender)
        } else {
            coordinator.present(scene: .tag({ [weak self] tags in
                self?.selectedTags = tags
                },selectedTags), sender: sender)
        }
    }
    func addReminder(sender: UIViewController) {
        coordinator.present(scene: .reminder(interview!), sender: sender)
    }
    func delete(tag: Tag) {
        if let index = selectedTags.firstIndex(of: tag) {
            selectedTags.remove(at: index)
            var snapShot = NSDiffableDataSourceSnapshot<Int,Tag>()
            snapShot.appendSections([1])
            snapShot.appendItems(selectedTags)
            tagDatasource.apply(snapShot)
        }
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
    func save(link: String?, interviewer: String?, desc: String?) -> Bool {
        if isEditingMode {
            do {
                try interviewService.update(interview: interview!, date: interviewDate, link: link == nil ? nil : URL(string: link!), interviewer: interviewer, role: selectedRole, desc: desc, tags: selectedTags)
                return true
            } catch {
                delegate?.error(text: GeneralMessages.unknown.rawValue)
                return false
            }
        } else {
            guard let date = interviewDate, let role = selectedRole else {
                delegate?.error(text: "Please select your interview date")
                return false
            }
            do {
                interview = try interviewService.save(date: date, link: link == nil ? nil : URL(string: link!), interviewer: interviewer, role: role, desc: desc, tags: selectedTags, for: apply)
                reminderSnapShot()
                return true
            } catch {
                delegate?.error(text: GeneralMessages.unknown.rawValue)
                return false
            }
        }
    }
}
// MARK: - Extensions -
extension InterviewViewModel: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        roles.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        roles[row].rawValue
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRole = roles[row]
    }
}
