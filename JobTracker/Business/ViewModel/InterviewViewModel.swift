//
//  InterviewViewModel.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 7/11/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class InterviewViewModel: NSObject {
    // MARK: - Properties -
    let appCoordinator = (UIApplication.shared.delegate as! AppDelegate).appCoordinator
    let interviewService: InterviewServiceType
    let tagService: TagServiceType
    var roleTextSetter: ((String) -> ())?
    var selectedRole: InterviewerRole? {
        didSet {
            guard let selectedRole = selectedRole else {return}
            roleTextSetter?(selectedRole.rawValue)
        }
    }
    var roles: [InterviewerRole] = []
    var selectedTags: [Tag] = [] {
        didSet {
            var snapShot = NSDiffableDataSourceSnapshot<Int,Tag>()
            snapShot.appendSections([1])
            snapShot.appendItems(selectedTags)
            tagDatasource.apply(snapShot)
        }
    }
    var tagDatasource: UICollectionViewDiffableDataSource<Int,Tag>!
    // MARK: - Initializer -
    init(interviewService: InterviewServiceType, tagService: TagServiceType) {
        self.interviewService = interviewService
        self.tagService = tagService
    }
    // MARK: - Functions -
    private var dateTextSetter: ((String) -> Void)?
    private var interviewDate: Date? {
        didSet {
            guard let interviewDate = interviewDate else {return}
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mm a"
            dateTextSetter?(dateFormatter.string(from: interviewDate))
        }
    }
    func set(date: Date) {
        interviewDate = date
    }
    func dateText(setter: @escaping (String) -> Void) {
        dateTextSetter = setter
    }
    func configureRole(pickerView: UIPickerView) {
        roles = interviewService.getAllRoles()
        selectedRole = roles.first
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    func roleText(setter: @escaping (String) -> Void) {
        roleTextSetter = setter
    }
    func configureTags(collectionView: UICollectionView) {
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
        var snapShot = NSDiffableDataSourceSnapshot<Int,Tag>()
        snapShot.appendSections([1])
        snapShot.appendItems(selectedTags)
        tagDatasource.apply(snapShot)
    }
    func addTags(sender: UIViewController) {
        appCoordinator?.present(scene: .tag({ [weak self] tags in
            self?.selectedTags = tags
            var snapShot = NSDiffableDataSourceSnapshot<Int,Tag>()
            snapShot.appendSections([1])
            snapShot.appendItems(tags)
            self?.tagDatasource.apply(snapShot)
            },selectedTags), sender: sender)
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
