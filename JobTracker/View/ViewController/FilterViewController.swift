//
//  FilterViewController.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 7/1/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, ViewModelSupportedViewControllers {
    // MARK: - Properties -
    var viewModel: FilterViewModel!
    var hasInterview = false
    var hasTask = false
    var isCompanyFavorite = false
    // MARK: - Outlet -
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet weak var colFilteredTag: UICollectionView!
    @IBOutlet weak var tblTag: UITableView!
    @IBOutlet weak var srbTag: UISearchBar!
    @IBOutlet weak var colFilteredCity: UICollectionView!
    @IBOutlet weak var tblCity: UITableView!
    @IBOutlet weak var srbCity: UISearchBar!
    @IBOutlet weak var pickStatus: UIPickerView!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet var viewCity: UIView!
    @IBOutlet var viewTag: UIView!
    @IBOutlet var viewState: UIView!
    @IBOutlet weak var segFilter: UISegmentedControl!
    // MARK: - Action -
    @IBAction func activeFilter(_ sender: Any) {
    }
    @IBAction func cancelFilter(_ sender: Any) {
    }
    @IBAction func interviewChanged(_ sender: Any) {
        hasInterview.toggle()
    }
    @IBAction func taskChanged(_ sender: Any) {
        hasTask.toggle()
    }
    @IBAction func companyChanged(_ sender: Any) {
        isCompanyFavorite.toggle()
    }
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewCity.isHidden = false
            viewTag.isHidden = true
            viewState.isHidden = true
        case 1:
            viewCity.isHidden = true
            viewTag.isHidden = false
            viewState.isHidden = true
        case 2:
            viewCity.isHidden = true
            viewTag.isHidden = true
            viewState.isHidden = false
        default:
            return
        }
    }
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let barBtnCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        navigationItem.leftBarButtonItem = barBtnCancel
        setup()
    }
    // MARK: - Functions -
    func setup() {
        configureSegmentViews()
    }
    func configureSegmentViews() {
        segmentView.addSubview(viewCity)
        segmentView.addSubview(viewTag)
        segmentView.addSubview(viewState)
        viewCity.translatesAutoresizingMaskIntoConstraints = false
        viewTag.translatesAutoresizingMaskIntoConstraints = false
        viewState.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewCity.leadingAnchor.constraint(equalTo: segmentView.leadingAnchor),
            viewCity.trailingAnchor.constraint(equalTo: segmentView.trailingAnchor),
            viewCity.topAnchor.constraint(equalTo: segmentView.topAnchor),
            viewCity.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor),
            viewTag.leadingAnchor.constraint(equalTo: segmentView.leadingAnchor),
            viewTag.trailingAnchor.constraint(equalTo: segmentView.trailingAnchor),
            viewTag.topAnchor.constraint(equalTo: segmentView.topAnchor),
            viewTag.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor),
            viewState.leadingAnchor.constraint(equalTo: segmentView.leadingAnchor),
            viewState.trailingAnchor.constraint(equalTo: segmentView.trailingAnchor),
            viewState.topAnchor.constraint(equalTo: segmentView.topAnchor),
            viewState.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor)
        ])
        viewTag.isHidden = true
        viewState.isHidden = true
        segFilter.selectedSegmentIndex = 0
    }
}
// MARK: - Extension -
extension FilterViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    
  }
}
