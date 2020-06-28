//
//  NewApplyViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/10/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class NewApplyViewController: UIViewController, ViewModelSupportedViewControllers {
    
    // MARK: - ViewModel
    var viewModel: NewApplyViewModel!
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var pkvResume: UIPickerView!
    @IBOutlet weak var pkvStatus: UIPickerView!
    @IBOutlet weak var pkvCountry: UIPickerView!
    @IBOutlet weak var pkvCity: UIPickerView!
    @IBOutlet weak var pkvDate: UIDatePicker!
    
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var txtJobURL: UITextField!
    @IBOutlet weak var txtApplyDate: UITextField!
    @IBOutlet weak var txtSalary: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var vwDatePicker: UIView!
    @IBOutlet weak var vwCountryPicker: UIView!
    @IBOutlet weak var vwCityPicker: UIView!
    @IBOutlet weak var imgHeart: UIImageView!
    // MARK: - Actions
    @IBAction func btnSave(_ sender: Any) {
        
    }
    
    @IBAction func btnDateViewCancel(_ sender: Any) {
        txtApplyDate.resignFirstResponder()
    }
    @IBAction func btnDateViewDone(_ sender: Any) {
        
    }
    @IBAction func btnCountryViewCancel(_ sender: Any) {
        txtCountry.resignFirstResponder()
    }
    @IBAction func btnCountryViewDone(_ sender: Any) {
        
    }
    @IBAction func btnCountryViewAdd(_ sender: Any) {
        
    }
    @IBAction func btnCityViewCancel(_ sender: Any) {
        txtCity.resignFirstResponder()
    }
    @IBAction func btnCityViewDone(_ sender: Any) {
        
    }
    @IBAction func btnCityViewAdd(_ sender: Any) {
        
    }
    
    @IBAction func tapOnHeart(_ sender: Any) {
        heartState.toggle()
    }
    
    // MARK: - Properties
    var heartState: Bool = false {
        didSet {
            if heartState {
                imgHeart.image = UIImage(systemName: "heart.fill")
            } else {
                imgHeart.image = UIImage(systemName: "heart")
            }
        }
    }
    var blurEffect: UIBlurEffect?
    var blurEffectView: UIVisualEffectView?
        
    // MARK: - Functions
    fileprivate func activateBlur() {
        blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.alpha = 0.95
        blurEffectView?.frame = view.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let blurEffectView = blurEffectView {
            self.view.addSubview(blurEffectView)
        }
    }
    
    fileprivate func deactiveBlur() {
        self.blurEffectView?.removeFromSuperview()
    }
    
    @objc func tapSalaryDone(sender: Any?) {
        txtSalary.resignFirstResponder()
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtApplyDate.inputView = vwDatePicker
        txtCountry.inputView = vwCountryPicker
        txtCity.inputView = vwCityPicker
        self.txtSalary.addDoneButton(title: "Done", target: self, selector: #selector(tapSalaryDone(sender:)))
    }
    
    
}



extension NewApplyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.accessibilityIdentifier {
        case "Country":
            return 10
        case "City":
            return 20
        case "Resume":
            return 3
        case "Status":
            return 5
        default:
            return 22
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.accessibilityIdentifier {
        case "Country":
            return "Germany"
        case "City":
            return "Berlin"
        case "Resume":
            return "V2.3"
        case "Status":
            return "HR"
        default:
            return "Unknown"
        }
    }
    
}

extension NewApplyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.accessibilityIdentifier == "ApplyDate" ||
            textField.accessibilityIdentifier == "Country" ||
            textField.accessibilityIdentifier == "City" ||
            textField.accessibilityIdentifier == "Salary" {
            activateBlur()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        deactiveBlur()
    }
}
