//
//  CompanyViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/30/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class CompanyViewController: UIViewController, ViewModelSupportedViewControllers {
    
    // MARK: - Properties
    var viewModel: CompanyViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var tblCompanies: UITableView!
    @IBOutlet weak var srbSearchBar: UISearchBar!
    @IBOutlet weak var btnAddCompany: UIButton!
    
    // MARK: - Actions
    @IBAction func addCompany(_ sender: Any) {
        if let name = srbSearchBar.text {
            do {
                try viewModel.add(name: name)
            } catch let error as CompanyViewModelError {
                showAlert(text: error.rawValue)
            } catch {
                print(error)
            }
        }
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.configureCompany(tableView: tblCompanies)
        tblCompanies.delegate = self
        srbSearchBar.delegate = self
    }
    
    func showAlert(text: String) {
        let alertController = UIAlertController(title: "Warning!", message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.show(alertController, sender: self)
    }

}

extension CompanyViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            btnAddCompany.isEnabled = true
            viewModel.filterCompanies(by: searchText)
        } else {
            btnAddCompany.isEnabled = false
            viewModel.filterCompanies(by: searchText)
        }
    }
}

extension CompanyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(at: indexPath)
        self.dismiss(animated: true, completion: nil)
    }
}
