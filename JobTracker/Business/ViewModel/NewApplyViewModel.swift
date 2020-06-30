//
//  NewApplyViewModeType.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/27/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class NewApplyViewModel: NSObject {
    
    // MARK: - Properties
    let countryService: CountryServiceType
    let cityService: CityServiceType
    var countryResultController: NSFetchedResultsController<Country>?
    var cityResultController: NSFetchedResultsController<City>?
    var countryPickerView: UIPickerView?
    var cityPickerView: UIPickerView?
    var countryNameSetter: ((String?) -> Void)?
    var cityNameSetter: ((String?) -> Void)?
    var selectedCountry: Country? {
        didSet {
            countryNameSetter?(selectedCountry?.name)
        }
    }
    var selectedCity: City? {
        didSet {
            cityNameSetter?(selectedCity?.name)
        }
    }
    
    // MARK: - Initializer
    init(countryService: CountryServiceType, cityService: CityServiceType) {
        self.countryService = countryService
        self.cityService = cityService
    }
    
    // MARK: - Functions
    func configureCountry(pickerView: UIPickerView) {
        pickerView.accessibilityIdentifier = "CountryPickerView"
        countryPickerView = pickerView
        countryResultController = countryService.fetchAll()
        let countryResultsControllerDelegate = CountryResultsControllerDelegate()
        countryResultsControllerDelegate.countryPickerView = pickerView
        countryResultController?.delegate = countryResultsControllerDelegate
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
    func setCountryName(onChange: @escaping (String?) -> Void) {
        countryNameSetter = onChange
    }
    
    func setCityName(onChange: @escaping (String?) -> Void) {
        cityNameSetter = onChange
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
        }
    }
    
    class CityResultsControllerDelegate: NSObject, NSFetchedResultsControllerDelegate{
        var cityPickerView: UIPickerView?
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            self.cityPickerView?.reloadAllComponents()
        }
    }
}

