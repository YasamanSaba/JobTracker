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
    @IBOutlet weak var btnAdd: UIButton!
    
    
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
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.srbSearchBar.searchTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        viewModel.configureDatasource(for: tblTableView)
        viewModel.configureSelectedTags(collectionView: colTags)
    }
    // MARK: - Functions -
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
}

extension TagViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            btnAdd.isEnabled = true
            viewModel.filterTags(by: searchText)
        } else {
            btnAdd.isEnabled = false
            viewModel.filterTags(by: searchText)
        }
    }
}
extension TagViewController: TagViewModelDelegate {
}
