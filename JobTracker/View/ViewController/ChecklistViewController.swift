//
//  ChecklistViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/15/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class ChecklistViewController: UIViewController, ViewModelSupportedViewControllers {
    
    var viewModel: ChecklistViewModel!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtChecklistItem: UITextField!
    
    @IBAction func addChecklistItem(_ sender: Any) {
        if let title = txtChecklistItem.text {
            try? viewModel.add(title: title)
        }
    }
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.configure(tableView: tableView)
    }

}

extension ChecklistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        try? viewModel.selectItem(at: indexPath, tableView: tableView)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
