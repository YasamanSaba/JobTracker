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
    // MARK: - Properties
    var blurEffect: UIBlurEffect?
    var blurEffectView: UIVisualEffectView?
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
        if viewModel.save(link: url, salary: Int(salaryText)!) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
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
        pkvDate.maximumDate = Date()
        txtApplyDate.inputView = vwDatePicker
        txtCountry.inputView = vwCountryPicker
        txtCity.inputView = vwCityPicker
        txtState.inputView = vwState
        txtResume.inputView = vwResumePicker
        self.txtSalary.addDoneButton(title: "Done", target: self, selector: #selector(tapSalaryDone(sender:)))
        viewModel.start(tagCollectionView: colTags, statePickerView: pkvStatus, resumePickerView: pkvResume, cityPickerView: pkvCity, countryPickerView: pkvCountry)
    }
}
// MARK: - Extensions
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
extension NewApplyViewController: NewApplyViewModelDelegate {
    func country(text: String) {
        txtCountry.text = text
    }
    
    func city(text: String) {
        txtCity.text = text
    }
    
    func date(text: String) {
        txtApplyDate.text = text
    }
    
    func company(text: String) {
        btnCompany.setTitle(text, for: .normal)
    }
    
    func resume(text: String) {
        txtResume.text = text
    }
    
    func state(text: String) {
        txtState.text = text
    }
    
    func link(text: String) {
        txtJobURL.text = text
    }
    
    func salary(text: String) {
        txtSalary.text = text
    }
}
