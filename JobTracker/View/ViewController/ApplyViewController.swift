//
//  ApplyViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/13/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class ApplyViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var vwStateHeightConst: NSLayoutConstraint!
    @IBOutlet weak var lblPassedTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnCompanyName: UIButton!
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var btnResume: UIButton!
    @IBOutlet weak var txtTags: UITextView!
    @IBOutlet weak var pkrState: UIPickerView!
    @IBOutlet weak var vwState: UIView!
    
    // MARK: - Actions
    @IBAction func btnResumeTap(_ sender: Any) {
    }
    @IBAction func btnStateChangeDone(_ sender: Any) {
        UIView.animate(withDuration: 1.0){
                   self.vwStateHeightConst.constant = 0
                   self.vwState.isHidden = true
               }
    }
    @IBAction func btnCompany(_ sender: Any) {
    }
    @IBAction func btnAddInterview(_ sender: Any) {
    }
    @IBAction func btnAddTask(_ sender: Any) {
    }
    
    @IBAction func btnStateChange(_ sender: Any) {
        UIView.animate(withDuration: 1.0){
            self.vwStateHeightConst.constant = 88
            self.vwState.isHidden = false
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwStateHeightConst.constant = 0
        self.vwState.isHidden = true
    }
}


extension ApplyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        
        return cell
    }
}

extension ApplyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "Contract"
    }
    
}
