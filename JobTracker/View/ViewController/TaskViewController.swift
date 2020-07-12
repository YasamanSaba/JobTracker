//
//  TaskViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/11/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, ViewModelSupportedViewControllers {
    
    var viewModel: TaskViewModel!
    var assingDatePicker: UIDatePicker!
    var deadlinePicker: UIDatePicker!
    var blurEffect: UIBlurEffect?
    var blurEffectView: UIVisualEffectView?
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtAssignDate: UITextField!
    @IBOutlet weak var txtDeadlineDate: UITextField!
    @IBOutlet weak var txtLink: UITextField!
    @IBOutlet weak var tblReminder: UITableView!
    @IBOutlet weak var vwDeadlinePicker: UIView!
    @IBOutlet weak var vwAssignDatePicker: UIView!
    @IBOutlet weak var swIsFinished: UISwitch!
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
          disableControlls()
        } else {
            enableControlls()
        }
    }
    
    private func enableControlls() {
        self.view.subviews.forEach{$0.isUserInteractionEnabled = true}
    }
    private func disableControlls() {
        self.view.subviews.forEach{$0.isUserInteractionEnabled = false}
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
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveItem
        navigationItem.title = "Task"
        
        txtAssignDate.inputView = vwAssignDatePicker
        txtDeadlineDate.inputView = vwDeadlinePicker
        let titleAndURL = viewModel.getCurrentTitleAndURL()
        txtTitle.text = titleAndURL.0
        txtLink.text = titleAndURL.1
        
    }

    @objc func save() {
        
    }
}


extension TaskViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.accessibilityIdentifier == "AssignDate" || textField.accessibilityIdentifier == "Deadline" {
            activateBlur()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        deactiveBlur()
    }
}
