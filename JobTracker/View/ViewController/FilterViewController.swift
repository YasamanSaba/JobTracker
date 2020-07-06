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
    var hasInterview = false {
        didSet {
            viewModel.set(futureInterview: hasInterview)
        }
    }
    var hasTask = false {
        didSet {
            viewModel.set(task: hasTask)
        }
    }
    var isCompanyFavorite = false {
        didSet {
            viewModel.set(companyFavorite: isCompanyFavorite)
        }
    }
    private var searchController = UISearchController(searchResultsController: nil)
    // MARK: - Outlet -
    @IBOutlet weak var colFilter: UICollectionView!
    @IBOutlet weak var tblTag: UITableView!
    @IBOutlet weak var srbTag: UISearchBar!
    @IBOutlet weak var tblCity: UITableView!
    @IBOutlet weak var srbCity: UISearchBar!
    @IBOutlet weak var srbState: UISearchBar!
    @IBOutlet weak var tblState: UITableView!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet var viewCity: UIView!
    @IBOutlet var viewTag: UIView!
    @IBOutlet var viewState: UIView!
    @IBOutlet weak var segFilter: UISegmentedControl!
    // MARK: - Action -
    @IBAction func done(_ sender: Any) {
        viewModel.done()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelFilter(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        colFilter.collectionViewLayout = configureLayout()
        viewModel.setupCityDataSource(for: tblCity)
        viewModel.setupTagDataSource(for: tblTag)
        viewModel.setupStateDataSource(for: tblState)
        viewModel.setupFilterObjectDataSource(for: colFilter)
        srbCity.searchTextField.addTarget(self, action: #selector(cityTextChanged), for: .allEditingEvents)
        srbTag.searchTextField.addTarget(self, action: #selector(tagTextChanged), for: .allEditingEvents)
        srbState.searchTextField.addTarget(self, action: #selector(stateTextChanged), for: .allEditingEvents)
    }
    @objc func cityTextChanged() {
        viewModel.filterCity(for: srbCity.searchTextField.text ?? "")
    }
    @objc func tagTextChanged() {
        viewModel.filterTag(for: srbTag.searchTextField.text ?? "")
    }
    @objc func stateTextChanged() {
        viewModel.filterState(for: srbState.searchTextField.text ?? "")
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
    func configureLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        //section.orthogonalScrollingBehavior = .continuous
        return UICollectionViewCompositionalLayout(section: section)
    }
}
// MARK: - Extensions -
extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView{
        case tblCity:
            viewModel.addCity(at: indexPath)
            tableView.deselectRow(at: indexPath, animated: true)
        case tblTag:
            viewModel.addTag(at: indexPath)
            tableView.deselectRow(at: indexPath, animated: true)
        case tblState:
            viewModel.addState(at: indexPath)
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            return
        }
        
    }
}
