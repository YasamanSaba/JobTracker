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
    @IBOutlet weak var vwDatePicker: UIView!
    @IBOutlet weak var vwCountryPicker: UIView!
    @IBOutlet weak var vwCityPicker: UIView!
    @IBOutlet weak var imgHeart: UIImageView!
    @IBOutlet weak var colTags: UICollectionView!
    // MARK: - Actions
    @IBAction func btnSave(_ sender: Any) {
        
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
    @IBAction func btnCountryViewCancel(_ sender: Any) {
        txtCountry.resignFirstResponder()
    }
    @IBAction func btnCountryViewDone(_ sender: Any) {
        txtCountry.resignFirstResponder()
    }
    @IBAction func btnCountryViewAdd(_ sender: Any) {
        
    }
    @IBAction func btnCityViewCancel(_ sender: Any) {
        txtCity.resignFirstResponder()
    }
    @IBAction func btnCityViewDone(_ sender: Any) {
        txtCity.resignFirstResponder()
    }
    @IBAction func btnCityViewAdd(_ sender: Any) {
        
    }
    
    @IBAction func tapOnHeart(_ sender: Any) {
        heartState.toggle()
    }
    
    @IBAction func addTags(_ sender: Any) {
        viewModel.addTags(sender: self)
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
        viewModel.setCountryName{ [weak self] in
            self?.txtCountry.text = $0
        }
        viewModel.setCityName{ [weak self] in
            self?.txtCity.text = $0
        }
        viewModel.setDateText{ [weak self] in
            self?.txtApplyDate.text = $0
        }
        viewModel.setCompanyText{ [weak self] in
            self?.btnCompany.setTitle($0, for: .normal)
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
            textField.accessibilityIdentifier == "City" {
            activateBlur()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        deactiveBlur()
    }
}
