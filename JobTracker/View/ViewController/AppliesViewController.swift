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
    @IBAction func addCompany(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let task = Task(context: context)
        task.date = Date()
        task.isDone = false
        let calendar = Calendar.current
        task.deadline = calendar.date(byAdding: .day, value: 4, to: Date())
        task.title = "Teeeeest"
        let city9 = City(context: context)
        city9.name = "LA"
        let country9 = Country(context: context)
        country9.name = "US"
        country9.flag = "🇺🇸"
        country9.minSalary = 48000
        country9.addToCity(city9)
        let company9 = Company(context: context)
        company9.title = "Apple"
        company9.isFavorite = false
        let apply9 = Apply(context: context)
        apply9.date = Date()
        apply9.statusEnum = .hr
        apply9.jobLink = URL(string: "test")
        city9.addToApply(apply9)
        let resume9 = Resume(context: context)
        resume9.version = "11.5"
        resume9.addToApply(apply9)
        company9.addToApply(apply9)
        apply9.addToTask(task)
        
        let interview = Interview(context: context)
        interview.date = Date()
        interview.interviewerRoleEnum = .ceo
        let city8 = City(context: context)
        city8.name = "Tehran"
        let country8 = Country(context: context)
        country8.name = "Iran"
        country8.flag = "🇮🇷"
        country8.minSalary = 40000
        country8.addToCity(city8)
        let company8 = Company(context: context)
        company8.title = "Digi Kala"
        company8.isFavorite = true
        let apply8 = Apply(context: context)
        apply8.date = calendar.date(byAdding: .day, value: -4, to: Date())
        apply8.statusEnum = .challenge
        apply8.jobLink = URL(string: "google")
        city8.addToApply(apply8)
        let resume8 = Resume(context: context)
        resume8.version = "8.4"
        resume8.addToApply(apply8)
        company8.addToApply(apply8)
        apply8.addToInterview(interview)
        
        let city = City(context: context)
        city.name = "Munich"
        let country = Country(context: context)
        country.name = "Germany"
        country.minSalary = 70000
        country.flag = "🇩🇪"
        country.addToCity(city)
        
        let company = Company(context: context)
        company.title = "StarBox"
        company.isFavorite = false
        let resume = Resume(context: context)
        resume.version = "1.4"
        let apply = Apply(context: context)
        apply.date = Date()
        apply.statusEnum = .hr
        apply.salaryExpectation = 54000
        apply.jobLink = URL(string: "https://www.linkedin.com")
        city.addToApply(apply)
        resume.addToApply(apply)
        company.addToApply(apply)
        
        
        let barcelona = City(context: context)
        barcelona.name = "Barcelona"
        let spain = Country(context: context)
        spain.name = "Spain"
        spain.minSalary = 734676
        spain.flag = "🇪🇸"
        spain.addToCity(barcelona)
        let company2 = Company(context: context)
        company2.title = "fly"
        company2.isFavorite = false
        let resume2 = Resume(context: context)
        resume2.version = "2.3"
        let apply2 = Apply(context: context)
        apply2.date = Date()
        apply2.statusEnum = .contract
        apply2.salaryExpectation = 52000
        apply2.jobLink = URL(string: "https://www.mofidonline.com")
        barcelona.addToApply(apply2)
        resume2.addToApply(apply2)
        company2.addToApply(apply2)
        
        let london = City(context: context)
        london.name = "London"
        let england = Country(context: context)
        england.name = "England"
        england.minSalary = 87342
        england.flag = "🏴󠁧󠁢󠁥󠁮󠁧󠁿"
        england.addToCity(london)
        let company3 = Company(context: context)
        company3.title = "Polo"
        company3.isFavorite = true
        let resume3 = Resume(context: context)
        resume3.version = "5.8"
        let apply3 = Apply(context: context)
        apply3.date = Date()
        apply3.statusEnum = .rejected
        apply3.salaryExpectation = 52000
        apply3.jobLink = URL(string: "https://www.yahoo.com")
        london.addToApply(apply3)
        resume3.addToApply(apply3)
        company3.addToApply(apply3)
        
        try! context.save()
    }
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
    // MARK: - Properties
    static let badgeElementKind = "badge-element-kind"
    var viewModel: AppliesViewModel!
    private var searchController = UISearchController(searchResultsController: nil)
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Temporary
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let countryService = CountryService(context: context)
        let applyService = ApplyService(context: context)
        self.viewModel = AppliesViewModel(countryService: countryService, applyService: applyService)
        setUpView()
    }
    // MARK: - Functions
    private func setUpView() {
        collectionView.delegate = self
        tableView.delegate = self
        collectionView.register(BadgeSupplementaryView.self, forSupplementaryViewOfKind: AppliesViewController.badgeElementKind, withReuseIdentifier: BadgeSupplementaryView.reuseIdentifier)
        collectionView.collectionViewLayout = configureLayout()
        self.viewModel.configureApplyDataSource(for: self.tableView)
        self.viewModel.configureCountryDataSource(for: self.collectionView)
        configureSearchController()
        createNonEditingBarButtons()
    }
    func createNonEditingBarButtons() {
        let btnAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        let btnEdit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editApplies))
        let btnFilter = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"), style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [btnAdd, btnEdit]
        navigationItem.leftBarButtonItem = btnFilter
    }
    func configureLayout() -> UICollectionViewCompositionalLayout {
        let anchorEdges: NSDirectionalRectEdge = [.top, .trailing]
        let offset = CGPoint(x: 0.2, y: -0.2)
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
            navigationItem.rightBarButtonItem = doneBarBut
            navigationItem.leftBarButtonItem = trashBarBut
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

