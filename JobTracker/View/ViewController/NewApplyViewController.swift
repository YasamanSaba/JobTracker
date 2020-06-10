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
    @IBAction func btnAddTag(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
