//
//  NewApplyViewModeType.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/27/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

enum NewApplyViewModelError: String, Error {
    case inCompleteDataToSave = "Please fill all the fields."
    case unKnownError = "Please try again later."
}

class NewApplyViewModel: NSObject {
    
    // MARK: - Properties
    let appCoordinator = (UIApplication.shared.delegate as! AppDelegate).appCoordinator
    let applyService: ApplyServiceType
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
    var countryNameSetter: ((String?) -> Void)?
    var cityNameSetter: ((String?) -> Void)?
    var dateSetter: ((String?) -> Void)?
    var companySetter: ((String?) -> Void)?
    var selectedResume: Resume?
    var states: [Status] = []
    var selectedStateIndex: Int = 0
    var selectedTags: [Tag] = []
    var selectedCountry: Country? {
        didSet {
            countryNameSetter?(selectedCountry?.name)
            selectedCity = nil
        }
    }
    var selectedCity: City? {
        didSet {
            cityNameSetter?(selectedCity?.name)
        }
    }
    var selectedDate: Date? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MMM-dd"
            dateSetter?(dateFormatter.string(from: selectedDate ?? Date()))
        }
    }
    var selectedComapy: Company? {
        didSet {
            companySetter?(selectedComapy?.title ?? "Unknown")
        }
    }
    
    // MARK: - Initializer
    init(countryService: CountryServiceType, cityService: CityServiceType, applyService: ApplyServiceType, tagService: TagServiceType) {
        self.countryService = countryService
        self.cityService = cityService
        self.applyService = applyService
        self.tagService = tagService
    }
    
    // MARK: - Functions
    func configureCountry(pickerView: UIPickerView) {
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
    
    func configureCity(pickerView: UIPickerView) {
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
    
    func set(date: Date) {
        selectedDate = date
    }
    
    func setCountryName(onChange: @escaping (String?) -> Void) {
        countryNameSetter = onChange
    }
    
    func setCityName(onChange: @escaping (String?) -> Void) {
        cityNameSetter = onChange
    }
    
    func setDateText(onChange: @escaping (String?) -> Void) {
        dateSetter = onChange
    }
    
    func setCompanyText(onChange: @escaping (String?) -> Void) {
        companySetter = onChange
    }
    
    func configureResume(pickerView: UIPickerView) {
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
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func configureState(pickerView: UIPickerView) {
        self.states = applyService.getAllState()
        pickerView.accessibilityIdentifier = "StatePickerView"
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func addContry(sender: UIViewController) {
        appCoordinator?.present(scene: .country, sender: sender)
    }
    
    func addCity(sender: UIViewController) {
        if let selectedCountry = selectedCountry {
            appCoordinator?.present(scene: .city(selectedCountry), sender: sender)
        }
    }
    
    func configureTags(collectionView: UICollectionView) {
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
        appCoordinator?.present(scene: .tag({ [weak self] tags in
            self?.selectedTags = tags
            var snapShot = NSDiffableDataSourceSnapshot<Int,Tag>()
            snapShot.appendSections([1])
            snapShot.appendItems(tags)
            self?.tagDatasource.apply(snapShot)
        }), sender: sender)
    }
    
    func chooseCompany(sender: UIViewController) {
        appCoordinator?.present(scene: .company({ [weak self] company in
            self?.selectedComapy = company
        }), sender: sender)
    }
    
    func addResume(sender: UIViewController) {
        appCoordinator?.present(scene: .resume, sender: sender)
    }
    func save(link: String, salary: Int) throws {
        if let url = URL(string: link),
            let city = selectedCity,
            let date = selectedDate,
            let company = selectedComapy,
            let resume = selectedResume
        {
            let item = ApplyService.ApplyItem(date: date, link: url, salary: salary, state: states[selectedStateIndex], city: city, company: company, resume: resume, tags: selectedTags)
            do {
                try applyService.save(applyItem: item)
            } catch {
                throw NewApplyViewModelError.unKnownError
            }
        } else {
            throw NewApplyViewModelError.inCompleteDataToSave
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

