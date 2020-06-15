//
//  NewApplyViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/10/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class NewApplyViewController: UIViewController {
    
    
    
    // MARK: - Outlets
    @IBOutlet weak var pkvCountry: UIPickerView!
    @IBOutlet weak var pkvCity: UIPickerView!
    @IBOutlet weak var pkvResume: UIPickerView!
    @IBOutlet weak var pkvStatus: UIPickerView!
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var txtJobURL: UITextField!
    @IBOutlet weak var txtTags: UITextView!
    @IBOutlet weak var dpkvApplyDate: UIDatePicker!
    
    // MARK: - Actions
    @IBAction func btnSave(_ sender: Any) {
        
    }

    
    // MARK: - Properties
    var tags: String = "" {
        didSet{
            txtTags.text = tags
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if txtJobURL.isFirstResponder {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
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
}
