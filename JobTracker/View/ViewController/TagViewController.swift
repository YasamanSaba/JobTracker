//
//  TagViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/13/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class TagViewController: UIViewController, ViewModelSupportedViewControllers {
    
    // MARK: - Properties
    var viewModel: TagViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var srbSearchBar: UISearchBar!
    @IBOutlet weak var tblTableView: UITableView!
    @IBOutlet weak var colTags: UICollectionView!
    
    
    // MARK: - Actions
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        viewModel.save()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        if let title = srbSearchBar.text {
            viewModel.addNew(tag: title)
            srbSearchBar.text = ""
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.srbSearchBar.searchTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        viewModel.start(collectionView: colTags, tableView: tblTableView)
    }
    // MARK: - Functions
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
}
// MARK: - Extensions
extension TagViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            viewModel.filterTags(by: searchText)
        } else {
            viewModel.filterTags(by: searchText)
        }
    }
}
extension TagViewController: TagViewModelDelegate {
}
