//
//  InterviewViewController.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 7/11/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class InterviewViewController: UIViewController, ViewModelSupportedViewControllers {
    // MARK: - Properties -
    var viewModel: InterviewViewModel!
    var datePicker: UIDatePicker!
    var rolePickerView: UIPickerView!
    // MARK: - IBOutlet -
    @IBOutlet weak var txtInterviewDate: UITextField!
    @IBOutlet weak var txtInterviewLink: UITextField!
    @IBOutlet weak var txtInterviewerName: UITextField!
    @IBOutlet weak var txtInterviewerRole: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var colTag: UICollectionView!
    @IBOutlet weak var tblReminder: UITableView!
    // MARK: - IBAction -
    
    @IBAction func btnAddTag(_ sender: Any) {
        viewModel.addTags(sender: self)
    }
    // MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        let btnSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
        navigationItem.rightBarButtonItem = btnSave
        setup()
    }
    // MARK: - Functions -
    func setup() {
        configureTextBoxDatePicker()
        viewModel.dateText { [weak self] in
            self?.txtInterviewDate.text = $0
        }
        viewModel.roleText { [weak self] in
            self?.txtInterviewerRole.text = $0
        }
        configureTextBoxInterviewerRole()
        viewModel.configureRole(pickerView: rolePickerView)
        viewModel.configureTags(collectionView: colTag)
        txtInterviewDate.tintColor = .clear
        txtInterviewerRole.tintColor = .clear
    }
    func configureTextBoxDatePicker() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemBlue
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelDatePicker))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.txtInterviewDate.inputView = datePicker
        self.txtInterviewDate.inputAccessoryView = toolBar
    }
    func configureTextBoxInterviewerRole() {
        rolePickerView = UIPickerView()
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemBlue
        toolBar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDatePicker))
        toolBar.setItems([spaceButton, doneButton], animated: false)
        txtInterviewerRole.inputView = rolePickerView
        txtInterviewerRole.inputAccessoryView = toolBar
    }
    @objc func cancelDatePicker() {
        txtInterviewDate.resignFirstResponder()
    }
    @objc func saveDatePicker() {
        let interviewDate = datePicker.date
        viewModel.set(date: interviewDate)
        txtInterviewDate.resignFirstResponder()
    }
    @objc func doneDatePicker() {
        txtInterviewerRole.resignFirstResponder()
    }
}
// MARK: - Extension -
extension InterviewViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
