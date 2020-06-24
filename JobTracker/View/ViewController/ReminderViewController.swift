//
//  ReminderViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController, ViewModelSupportedViewControllers {

    // MARK: - Outlets
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var dpkDate: UIDatePicker!
    
    // MARK: - Actions
    @IBAction func btnDone(_ sender: Any) {
        viewModel.setReminder(date: dpkDate.date, message: txtMessage.text ?? "") { [weak self] success in
            guard let self = self else { return }
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Error", message: "Your reminder haven't set. try again later", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
                    alertController.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(alertAction)
                self.show(alertController, sender: self)
            }
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - ViewModel
    var viewModel: ReminderViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
