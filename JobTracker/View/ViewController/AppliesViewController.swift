//
//  AppliesViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/10/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class AppliesViewController: UIViewController {
    
    enum Section {
        case main
    }
    var dataSource: UICollectionViewDiffableDataSource<Section, Country>!
    var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Country>()
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        tableView.dataSource = self
        collectionView.collectionViewLayout = configureLayout()
        configureDataSource()
        
    }
    
    func configureLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Country>(collectionView: self.collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlagCell.reuseIdentifier, for: indexPath) as! FlagCell
            
            cell.lblCountryName.text = item.name
            cell.lblFlag.text = item.flag
            return cell
        }
        
        // MARK: - This is for test clean it -
        let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var countries: [Country] = []
        let c1 = Country(context: contex)
        c1.name = "Germany"
        c1.flag = "🇩🇪"
        countries.append(c1)
        
        let c2 = Country(context: contex)
        c2.name = "Italy"
        c2.flag = "🇮🇹"
        countries.append(c2)

        let c3 = Country(context: contex)
        c3.name = "USA"
        c3.flag = "🇺🇸"
        countries.append(c3)
        
        let c4 = Country(context: contex)
        c4.name = "USA"
        c4.flag = "🇺🇸"
        countries.append(c4)
        
        let c5 = Country(context: contex)
        c5.name = "USA"
        c5.flag = "🇺🇸"
        countries.append(c5)
        // MARK: - Testing finished -
                
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(countries, toSection: .main)
        dataSource.apply(initialSnapshot)
    }
}


extension AppliesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ApplyCell") else {
            return UITableViewCell()
        }
        return cell
    }
}
