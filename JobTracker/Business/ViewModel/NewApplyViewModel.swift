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
    weak var countryResultController: NSFetchedResultsController<Country>?
    weak var cityResultController: NSFetchedResultsController<City>?
    
    // MARK: - Initializer
    init(countryService: CountryServiceType) {
        self.countryService = countryService
    }
    
    // MARK: - Functions
    func configureCountry(pickerView: UIPickerView) {
        pickerView.accessibilityIdentifier = "CountryPickerView"
        countryResultController = countryService.fetchAll()
        let countryResultsControllerDelegate = CountryResultsControllerDelegate()
        countryResultsControllerDelegate.countryPickerView = pickerView
        countryResultController?.delegate = countryResultsControllerDelegate
        pickerView.dataSource = self
        pickerView.delegate = self
        do {
            try countryResultController?.performFetch()
            
        } catch {
            print(error)
        }
    }
    
    func configureCity(pickerView: UIPickerView) {
        pickerView.accessibilityIdentifier = "CityPickerView"
            //cityResultController =
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
        //case "CityPickerView":
            
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
        default:
            return nil
        }
    }
}

extension NewApplyViewModel {
    class CountryResultsControllerDelegate: NSObject, NSFetchedResultsControllerDelegate{
        weak var countryPickerView: UIPickerView?
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            self.countryPickerView?.reloadAllComponents()
        }
    }
    
}

