//
//  NotesViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/23/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController, ViewModelSupportedViewControllers {
    // MARK: - Properties
    var viewModel: NotesViewModel!
    @IBOutlet weak var tblNotes: UITableView!
    @IBAction func btnAdd(_ sender: Any) {
        viewModel.add(sender: self)
    }
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start(tableView: tblNotes)
    }
}
// MARK: - Extensions
extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(at: indexPath, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension NotesViewController: NotesViewModelDelegate {
}
