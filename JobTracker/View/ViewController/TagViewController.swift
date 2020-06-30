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
    var selectedTags: [String]! {
        didSet{
            let hashTags = selectedTags.map{tag in
                return "#" + tag
            }
            txtTag.text = hashTags.joined(separator: " ")
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var srbSearchBar: UISearchBar!
    @IBOutlet weak var tblTableView: UITableView!
    @IBOutlet weak var txtTag: UITextView!
    @IBOutlet weak var btnAdd: UIButton!
    
    
    // MARK: - Actions
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        viewModel.save(tags: selectedTags ?? [])
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        if let title = srbSearchBar.text {
            do {
                try viewModel.addNew(tag: title)
            } catch TagViewModelError.alreadyExists {
                let alertController = UIAlertController(title: "Can't add", message: "This tag already exists.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
                    alertController.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(alertAction)
                self.show(alertController, sender: self)
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tblTableView.delegate = self
        self.srbSearchBar.searchTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        if selectedTags == nil {
            selectedTags = []
        }
        viewModel.configureDatasource(for: tblTableView)
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
}

extension TagViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TagTableViewCell {
            if let tag = cell.lblTitle.text {
                if selectedTags.contains(tag) {
                    let index = selectedTags.firstIndex(of: tag)
                    if let intIndex = index {
                        selectedTags.remove(at: intIndex)
                    }
                } else {
                    selectedTags.append(tag)
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TagViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            btnAdd.isEnabled = true
            viewModel.filterTags(by: searchText)
        } else {
            btnAdd.isEnabled = false
        }
    }
}
