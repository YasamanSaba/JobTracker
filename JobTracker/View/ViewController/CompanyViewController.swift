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
    var heartState: Bool = false {
        didSet {
            if heartState {
                imgHeart.image = UIImage(systemName: "heart.fill")
            } else {
                imgHeart.image = UIImage(systemName: "heart")
            }
        }
    }
    // MARK: - Outlets
    @IBOutlet weak var tblCompanies: UITableView!
    @IBOutlet weak var srbSearchBar: UISearchBar!
    //@IBOutlet weak var btnAddCompany: UIButton!
    @IBOutlet weak var imgHeart: UIImageView!
    //@IBOutlet weak var txtCompanyName: UITextField!
    // MARK: - Actions
    @IBAction func addCompany(_ sender: Any) {
        if let name = srbSearchBar.text {
            viewModel.add(name: name,isFavorite: heartState)
            srbSearchBar.text = ""
        }
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tapOnHeart(_ sender: Any) {
        heartState.toggle()
    }
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start(tableView: tblCompanies)
        tblCompanies.delegate = self
    }
}
// MARK: - Extensions
extension CompanyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(at: indexPath)
        self.dismiss(animated: true, completion: nil)
    }
}
extension CompanyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension CompanyViewController: CompanyViewModelDelegate {
    
}
extension CompanyViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            viewModel.filterCompanies(by: searchText)
        } else {
            viewModel.filterCompanies(by: searchText)
        }
    }
}
