//
//  ResumeViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/4/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class ResumeViewController: UIViewController, ViewModelSupportedViewControllers {
    
    // MARK: - ViewModel
    var viewModel: ResumeViewModel!
    
    // MARK: - OUtlets
    @IBOutlet weak var tblResumes: UITableView!
    @IBOutlet weak var pkvVersion: UIPickerView!
    @IBOutlet weak var txtURL: UITextField!
    
    
    // MARK: - Actions
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func add(_ sender: Any) {
        if let urlString = txtURL.text, urlString.count > 0 {
            do {
                try viewModel.add(urlString: urlString)
            } catch let error as ResumeViewModelError {
                showAlert(text: error.rawValue)
            } catch {
                print(error)
            }
        }else {
            showAlert(text: "Please fill URL field.")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.configureVersion(pickerView: pkvVersion)
        viewModel.configure(tableView: tblResumes)
    }

    func showAlert(text: String) {
        let alertController = UIAlertController(title: "Warning!", message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
