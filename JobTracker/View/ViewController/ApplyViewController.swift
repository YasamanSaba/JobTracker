//
//  ApplyViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/13/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class ApplyViewController: UIViewController, ViewModelSupportedViewControllers {
    // MARK: - Properties -
    var viewModel: ApplyViewModel!
    var states: [String] = []
    var blurEffect: UIBlurEffect!
    var blurEffectView: UIVisualEffectView!
    // MARK: - Outlets -
    @IBOutlet weak var lblPassedTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnCompanyName: UIButton!
    @IBOutlet weak var btnState: PickerButton!
    @IBOutlet weak var btnResume: UIButton!
    // MARK: - Actions -
    @IBAction func btnResumeTap(_ sender: Any) {
    }
    @IBAction func btnCompany(_ sender: Any) {
    }
    @IBAction func btnAddInterview(_ sender: Any) {
    }
    @IBAction func btnAddTask(_ sender: Any) {
    }
    @IBAction func btnStateChange(_ sender: PickerButton) {
        sender.becomeFirstResponder()
        blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
    }
    // MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    // MARK: - Functions -
    func setUp() {
        self.states = viewModel.getAllState()
        configureSatetPickerView()
    }
    func configureSatetPickerView() {
        let statePickerView = UIPickerView()
        statePickerView.accessibilityIdentifier = "StatePickerView"
        let toolbarStatePicker = UIToolbar()
        toolbarStatePicker.barStyle = UIBarStyle.default
        toolbarStatePicker.isTranslucent = true
        toolbarStatePicker.sizeToFit()
        let doneStatePRBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: nil)
        let spaceStatePRBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelStatePRBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolbarStatePicker.setItems([cancelStatePRBtn, spaceStatePRBtn, doneStatePRBtn], animated: false)
        toolbarStatePicker.isUserInteractionEnabled = true
        btnState.inputView = statePickerView
        btnState.inputAccessoryView = toolbarStatePicker
        statePickerView.dataSource = self
        statePickerView.delegate = self
    }
    @objc func cancelClick() {
        self.btnState.resignFirstResponder()
        self.blurEffectView.removeFromSuperview()
    }
}
// MARK: - Extensions -
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
        if pickerView.accessibilityIdentifier == "StatePickerView" {
            return states.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.accessibilityIdentifier == "StatePickerView" {
         return states[row]
        }
        return nil
    }
    
}
