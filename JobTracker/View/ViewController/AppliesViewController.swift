//
//  AppliesViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/10/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class AppliesViewController: UIViewController, ViewModelSupportedViewControllers {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Actions
    @IBAction func addApply(_ sender: Any) {
        viewModel.addApply(sender: self)
    }
    
    // MARK: - Test -
    @objc func editApplies() {
        self.setEditing(true, animated: true)
    }
    @objc func doneEditing() {
        self.setEditing(false, animated: true)
    }
    @objc func deleteSelectedItems() {
        if let selectedRows = tableView.indexPathsForSelectedRows, selectedRows.count > 0 {
            showDeleteAlert() { [weak self] decision in
                if decision {
                    self?.viewModel.deleteApplies(indexPaths: selectedRows)
                }
            }
        }
    }
    @objc func filter() {
        viewModel.filter(sender: self)
    }
    // MARK: - Properties
    static let badgeElementKind = "badge-element-kind"
    var viewModel: AppliesViewModel!
    private var searchController = UISearchController(searchResultsController: nil)
    var refreshControl = UIRefreshControl()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(tableViewRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        setUpView()
        viewModel.start(collectionView: collectionView, tableView: tableView)
    }
    // MARK: - Functions
    @objc func tableViewRefresh() {
        viewModel.start(collectionView: nil, tableView: tableView)
        refreshControl.endRefreshing()
    }
    private func setUpView() {
        collectionView.delegate = self
        tableView.delegate = self
        collectionView.register(BadgeSupplementaryView.self, forSupplementaryViewOfKind: AppliesViewController.badgeElementKind, withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier)
        collectionView.collectionViewLayout = configureLayout()
        configureSearchController()
        createNonEditingBarButtons()
        let btnFilter = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"), style: .done, target: self, action: #selector(filter))
        navigationItem.leftBarButtonItem = btnFilter
        viewModel.isFiltered() { [weak self] in
            if $0 {
                let btnResetFilter = UIBarButtonItem(title: "Reset Filters", style: .done, target: self, action: #selector(self?.resetFilters))
                self?.navigationItem.leftBarButtonItem = btnResetFilter
            } else {
                let btnFilter = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"), style: .done, target: self, action: #selector(self?.filter))
                self?.navigationItem.leftBarButtonItem = btnFilter
            }
        }
    }
    func createNonEditingBarButtons() {
        let btnEdit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editApplies))
        navigationItem.rightBarButtonItem = btnEdit
        
    }
    func configureLayout() -> UICollectionViewCompositionalLayout {
        let anchorEdges: NSDirectionalRectEdge = [.top, .trailing]
        let offset = CGPoint(x: 0.0, y: -0.0)
        let badgeAncher = NSCollectionLayoutAnchor(edges: anchorEdges, fractionalOffset: offset)
        let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(17), heightDimension: .absolute(17))
        let badge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize, elementKind: AppliesViewController.badgeElementKind, containerAnchor: badgeAncher)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge])
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return UICollectionViewCompositionalLayout(section: section)
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if isEditing {
            tableView.allowsSelectionDuringEditing = true
            tableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItems = nil
            let doneBarBut = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
            let trashBarBut = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteSelectedItems))
            navigationItem.rightBarButtonItems = [doneBarBut,trashBarBut]
        } else {
            tableView.setEditing(false, animated: true)
            createNonEditingBarButtons()
        }
    }
    func showDeleteAlert(onCompletion: @escaping (Bool)-> Void) {
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            onCompletion(false)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { _ in
            onCompletion(true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    @objc func resetFilters() {
        viewModel.resetFilters()
    }
}
// MARK: - Extensions
extension AppliesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.selectCountry(at: indexPath)
        if let cell = collectionView.cellForItem(at: indexPath) {
            let color:UIColor = .systemGray
            cell.backgroundColor = color.withAlphaComponent(0.23)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = nil
        }
    }
}
extension AppliesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            viewModel.showApplyDetail(for: indexPath, sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
}
// MARK: - UISearchResultsUpdating Delegate
extension AppliesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterCompanies(for: searchController.searchBar.text ?? "")
    }
    func configureSearchController() {
      searchController.searchResultsUpdater = self
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.placeholder = "Search Companies"
      navigationItem.searchController = searchController
      definesPresentationContext = true
    }
}
extension AppliesViewController: AppliesViewModelDelegate {
}
