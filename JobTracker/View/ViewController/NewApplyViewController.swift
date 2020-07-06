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
    
    @IBOutlet weak var btnCompany: UIButton!
    @IBOutlet weak var txtJobURL: UITextField!
    @IBOutlet weak var txtApplyDate: UITextField!
    @IBOutlet weak var txtSalary: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtResume: UITextField!
    @IBOutlet weak var vwDatePicker: UIView!
    @IBOutlet weak var vwCountryPicker: UIView!
    @IBOutlet weak var vwCityPicker: UIView!
    @IBOutlet weak var vwResumePicker: UIView!
    @IBOutlet weak var vwState: UIView!
    
    @IBOutlet weak var colTags: UICollectionView!
    // MARK: - Actions
    @IBAction func btnSave(_ sender: Any) {
        guard let url = txtJobURL.text, let salaryText = txtSalary.text, salaryText != "" else {
            showAlert(text: "Complete fields.")
            return
        }
        do {
            try viewModel.save(link: url, salary: Int(salaryText)!,sender: self)
        } catch let error as NewApplyViewModelError {
            showAlert(text: error.rawValue)
        } catch {
            print(error)
        }
    }
    @IBAction func addResume(_ sender: Any) {
        viewModel.addResume(sender: self)
    }
    @IBAction func btnChooseCompany(_ sender: Any) {
        viewModel.chooseCompany(sender: self)
    }
    @IBAction func btnDateViewCancel(_ sender: Any) {
        txtApplyDate.resignFirstResponder()
    }
    @IBAction func btnDateViewDone(_ sender: Any) {
        viewModel.set(date: pkvDate.date)
        txtApplyDate.resignFirstResponder()
    }
    @IBAction func btnResumeDone(_ sender: Any) {
        txtResume.resignFirstResponder()
    }
    @IBAction func btnCountryViewDone(_ sender: Any) {
        txtCountry.resignFirstResponder()
    }
    @IBAction func btnCountryViewAdd(_ sender: Any) {
        viewModel.addContry(sender: self)
    }
    
    @IBAction func btnCityViewDone(_ sender: Any) {
        txtCity.resignFirstResponder()
    }
    @IBAction func btnCityViewAdd(_ sender: Any) {
        viewModel.addCity(sender: self)
    }
    @IBAction func btnStateDone(_ sender: Any) {
        txtState.resignFirstResponder()
    }
    
    @IBAction func addTags(_ sender: Any) {
        viewModel.addTags(sender: self)
    }
    // MARK: - Properties

    var blurEffect: UIBlurEffect?
    var blurEffectView: UIVisualEffectView?
        
    // MARK: - Functions
    func showAlert(text: String) {
        let alertController = UIAlertController(title: "Warning!", message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
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
        txtState.inputView = vwState
        txtResume.inputView = vwResumePicker
        self.txtSalary.addDoneButton(title: "Done", target: self, selector: #selector(tapSalaryDone(sender:)))
        viewModel.setCountryName{ [weak self] in
            self?.txtCountry.text = $0
        }
        viewModel.setCityName{ [weak self] in
            self?.txtCity.text = $0 ?? ""
        }
        viewModel.setDateText{ [weak self] in
            self?.txtApplyDate.text = $0
        }
        viewModel.setCompanyText{ [weak self] in
            self?.btnCompany.setTitle($0, for: .normal)
        }
        viewModel.setResumeText{ [weak self] in
            self?.txtResume.text = $0
        }
        viewModel.setStateText{ [weak self] in
            self?.txtState.text = $0
        }
        viewModel.configureCountry(pickerView: pkvCountry)
        viewModel.configureCity(pickerView: pkvCity)
        viewModel.configureResume(pickerView: pkvResume)
        viewModel.configureState(pickerView: pkvStatus)
        viewModel.configureTags(collectionView: colTags)
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
            textField.accessibilityIdentifier == "State" ||
            textField.accessibilityIdentifier == "Resume" {
            activateBlur()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        deactiveBlur()
    }
}
