//
//  NewApplyViewModeType.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/27/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class NewApplyViewModel: NSObject, CoordinatorSupportedViewModel {
    // MARK: - Properties
    weak var delegate: NewApplyViewModelDelegate?
    var coordinator: CoordinatorType!
    let apply: Apply?
    let applyService: ApplyServiceType
    let stateService: StateServiceType
    let countryService: CountryServiceType
    let cityService: CityServiceType
    let tagService: TagServiceType
    var countryResultController: NSFetchedResultsController<Country>?
    var cityResultController: NSFetchedResultsController<City>?
    var resumeResultController: NSFetchedResultsController<Resume>!
    var tagDatasource: UICollectionViewDiffableDataSource<Int,Tag>!
    var resumeControllerDelegate: ResumeResultsControllerDelegate?
    var cityControllerDelegate: CityResultsControllerDelegate?
    var countryControllerDelegate: CountryResultsControllerDelegate?
    var countryPickerView: UIPickerView?
    var cityPickerView: UIPickerView?
    var states: [Status] = []
    var selectedStateIndex: Int = 0 {
        didSet {
            delegate?.state(text: states.count > 0 ? states[selectedStateIndex].rawValue : "No state")
        }
    }
    var selectedTags: [Tag] = [] {
        didSet {
            var snapShot = NSDiffableDataSourceSnapshot<Int,Tag>()
            snapShot.appendSections([1])
            snapShot.appendItems(selectedTags)
            tagDatasource.apply(snapShot)
        }
    }
    var selectedCountry: Country? {
        didSet {
            delegate?.country(text: selectedCountry?.name ?? "")
            selectedCity = nil
        }
    }
    var selectedCity: City? {
        didSet {
            delegate?.city(text: selectedCity?.name ?? "")
        }
    }
    var selectedDate: Date? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MMM-dd"
            delegate?.date(text: dateFormatter.string(from: selectedDate ?? Date()))
        }
    }
    var selectedComapy: Company? {
        didSet {
            delegate?.company(text: selectedComapy?.title ?? "Unknown")
        }
    }
    var selectedResume: Resume? {
        didSet {
            delegate?.resume(text: selectedResume?.version ?? "Unknown")
        }
    }
    var isEditingMode: Bool = false
    // MARK: - Initializer
    init(countryService: CountryServiceType, cityService: CityServiceType, applyService: ApplyServiceType, tagService: TagServiceType, stateService: StateServiceType, apply: Apply?) {
        self.countryService = countryService
        self.cityService = cityService
        self.applyService = applyService
        self.tagService = tagService
        self.stateService = stateService
        self.apply = apply
        if apply != nil {
            isEditingMode = true
        }
    }
    
    // MARK: - Functions
    private func configureCountry(pickerView: UIPickerView) {
        pickerView.accessibilityIdentifier = "CountryPickerView"
        countryPickerView = pickerView
        countryResultController = countryService.fetchAll()
        let countryResultsControllerDelegate = CountryResultsControllerDelegate()
        countryResultsControllerDelegate.countryPickerView = pickerView
        countryResultController?.delegate = countryResultsControllerDelegate
        self.countryControllerDelegate = countryResultsControllerDelegate
        pickerView.dataSource = self
        pickerView.delegate = self
        
        do {
            try countryResultController?.performFetch()
            pickerView.selectRow(0, inComponent: 0, animated: true)
            if let objects = countryResultController?.fetchedObjects, objects.count > 0 {
                selectedCountry = objects[0]
            }
        } catch {
            print(error)
        }
    }
    private func configureCity(pickerView: UIPickerView) {
        pickerView.accessibilityIdentifier = "CityPickerView"
        cityPickerView = pickerView
        if let selectedCountry = selectedCountry {
            cityResultController = cityService.fetchAll(in: selectedCountry)
            let cityResultsControllerDelegate = CityResultsControllerDelegate()
            cityResultsControllerDelegate.cityPickerView = pickerView
            cityResultController?.delegate = cityResultsControllerDelegate
            self.cityControllerDelegate = cityResultsControllerDelegate
            pickerView.dataSource = self
            pickerView.delegate = self
            do {
                try cityResultController?.performFetch()
                if let objects = cityResultController?.fetchedObjects, objects.count > 0 {
                pickerView.selectRow(0, inComponent: 0, animated: true)
                selectedCity = cityResultController?.fetchedObjects?[0]
                }
            } catch {
                print(error)
            }
        }
    }
    private func configureResume(pickerView: UIPickerView) {
        pickerView.accessibilityIdentifier = "ResumePickerView"
        resumeResultController = applyService.getAllResumeVersion()
        let resumeResultsControllerDelegate = ResumeResultsControllerDelegate()
        resumeResultsControllerDelegate.resumePickerView = pickerView
        self.resumeControllerDelegate = resumeResultsControllerDelegate
        resumeResultController.delegate = resumeResultsControllerDelegate
        do {
            try resumeResultController.performFetch()
            pickerView.delegate = self
            pickerView.dataSource = self
            if let objects = resumeResultController.fetchedObjects, objects.count > 0 {
                selectedResume = objects[0]
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    private func configureState(pickerView: UIPickerView) {
        self.states = stateService.getAllState()
        pickerView.accessibilityIdentifier = "StatePickerView"
        pickerView.delegate = self
        pickerView.dataSource = self
        if states.count > 0 {
            selectedStateIndex = 0
        }
    }
    private func configureTags(collectionView: UICollectionView) {
        tagDatasource = UICollectionViewDiffableDataSource<Int,Tag>(collectionView: collectionView) { (collectionView, indexPath, tag) -> UICollectionViewCell? in
            guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.reuseIdentifier, for: indexPath)
                as? TagCollectionViewCell else {return nil}
            cell.configure(tag: tag, onDelete: self.delete(tag:) )
            return cell
        }
        var snapShot = NSDiffableDataSourceSnapshot<Int,Tag>()
        snapShot.appendSections([1])
        snapShot.appendItems(selectedTags)
        tagDatasource.apply(snapShot)
    }
    func set(date: Date) {
        selectedDate = date
    }
    func addContry(sender: UIViewController) {
        coordinator.present(scene: .country, sender: sender)
    }
    func addCity(sender: UIViewController) {
        if let selectedCountry = selectedCountry {
            coordinator.present(scene: .city(selectedCountry), sender: sender)
        }
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
    func addTags(sender: UIViewController) {
        coordinator.present(scene: .tag({ [weak self] tags in
            self?.selectedTags = tags
            var snapShot = NSDiffableDataSourceSnapshot<Int,Tag>()
            snapShot.appendSections([1])
            snapShot.appendItems(tags)
            self?.tagDatasource.apply(snapShot)
        },selectedTags), sender: sender)
    }
    func chooseCompany(sender: UIViewController) {
        coordinator.present(scene: .company({ [weak self] company in
            self?.selectedComapy = company
        }), sender: sender)
    }
    func addResume(sender: UIViewController) {
        coordinator.present(scene: .resume, sender: sender)
    }
    func save(link: String?, salary: Int?) -> Bool {
        if let city = selectedCity,
            let date = selectedDate,
            let company = selectedComapy,
            let resume = selectedResume
        {
            let url = (link != nil) ? URL(string: link!) : nil
            let item = ApplyService.ApplyItem(date: date, link: url, salary: salary ?? 0, state: states[selectedStateIndex], city: city, company: company, resume: resume, tags: selectedTags)
            do {
                if isEditingMode {
                    try applyService.update(apply: apply!, company: company, city: city, country: city.country, link: url, salary: Int32(salary ?? 0), state: states[selectedStateIndex], resume: resume, date: date, tags: selectedTags)
                    return true
                } else {
                try applyService.save(applyItem: item)
                    return true
                }
            } catch {
                delegate?.error(text: "Please try again later.")
                return false
            }
        } else {
            delegate?.error(text: "Please fill all the fields.")
            return false
        }
    }
    func start(tagCollectionView: UICollectionView, statePickerView: UIPickerView, resumePickerView: UIPickerView, cityPickerView: UIPickerView, countryPickerView: UIPickerView) {
        configureTags(collectionView: tagCollectionView)
        configureState(pickerView: statePickerView)
        configureResume(pickerView: resumePickerView)
        configureCity(pickerView: cityPickerView)
        configureCountry(pickerView: countryPickerView)
        if isEditingMode, let apply = apply {
            selectedCountry = apply.city?.country
            selectedCity = apply.city
            selectedTags = apply.tag != nil ? apply.tag!.allObjects.map{$0 as! Tag} : []
            selectedDate = apply.date
            selectedComapy = apply.company
            selectedResume = apply.resume
            selectedStateIndex = states.firstIndex(of: apply.statusEnum!)!
            delegate?.link(text: apply.jobLink?.absoluteString ?? "")
            delegate?.salary(text: apply.salaryExpectation == 0 ? "" : String(apply.salaryExpectation))
        }
    }
}
// MARK: - Extensions
extension NewApplyViewModel: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.accessibilityIdentifier {
        case "CountryPickerView":
            if let objects = countryResultController?.fetchedObjects {
                return objects.count
            }
            return 0
        case "CityPickerView":
            if let objects = cityResultController?.fetchedObjects {
                return objects.count
            }
            return 0
        case "ResumePickerView":
            if let objects = resumeResultController?.fetchedObjects {
                return objects.count
            }
            return 0
        case "StatePickerView":
            return states.count
        default:
            return 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.accessibilityIdentifier {
        case "CountryPickerView":
            if let objects = countryResultController?.fetchedObjects {
                return objects[row].name
            }
            return nil
        case "CityPickerView":
            if let objects = cityResultController?.fetchedObjects {
                return objects[row].name
            }
            return nil
        case "ResumePickerView":
            if let objects = resumeResultController?.fetchedObjects {
                return objects[row].version
            }
            return nil
        case "StatePickerView":
            if row < states.count {
                return states[row].rawValue
            }
            return nil
        default:
            return nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.accessibilityIdentifier {
        case "CountryPickerView":
            if let objects = countryResultController?.fetchedObjects, objects.count > 0 {
                selectedCountry = objects[row]
                if let cityPickerView = cityPickerView {
                    configureCity(pickerView: cityPickerView)
                }
            }
        case "CityPickerView":
            selectedCity = cityResultController?.fetchedObjects?[row]
        case "ResumePickerView":
            if let objects = resumeResultController.fetchedObjects, row < objects.count {
                selectedResume = objects[row]
            }
        case "StatePickerView":
            selectedStateIndex = row
        default:
            return
        }
    }
}
extension NewApplyViewModel {
    class CountryResultsControllerDelegate: NSObject, NSFetchedResultsControllerDelegate{
        var countryPickerView: UIPickerView?
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            self.countryPickerView?.reloadAllComponents()
            self.countryPickerView?.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    class CityResultsControllerDelegate: NSObject, NSFetchedResultsControllerDelegate{
        var cityPickerView: UIPickerView?
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            self.cityPickerView?.reloadAllComponents()
            self.cityPickerView?.selectRow(0, inComponent: 0, animated: true)
            if let cityPickerView = cityPickerView {
                self.cityPickerView?.delegate?.pickerView?(cityPickerView, didSelectRow: 0, inComponent: 0)
            }
        }
    }
    
    class ResumeResultsControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
        var resumePickerView: UIPickerView?
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            self.resumePickerView?.reloadAllComponents()
            self.resumePickerView?.selectRow(0, inComponent: 0, animated: true)
            if let resumePickerView = resumePickerView {
                self.resumePickerView?.delegate?.pickerView?(resumePickerView, didSelectRow: 0, inComponent: 0)
            }
        }
    }
}

