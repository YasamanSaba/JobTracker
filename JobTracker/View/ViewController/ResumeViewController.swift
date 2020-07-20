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
        viewModel.add(urlString: txtURL.text)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start(tableView: tblResumes, pickerView: pkvVersion)
    }
}

extension ResumeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.openURL(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension ResumeViewController: ResumeViewModelDelegate {
    
}
