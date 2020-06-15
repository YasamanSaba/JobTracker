//
//  TagViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/13/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class TagViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var srbSearchBar: UISearchBar!
    @IBOutlet weak var tblTableView: UITableView!
    @IBOutlet weak var txtTag: UITextView!


    // MARK: - Actions
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDone(_ sender: Any) {
    }
    
    @IBAction func btnAdd(_ sender: Any) {
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
