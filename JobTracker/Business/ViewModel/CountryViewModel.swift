//
//  CountryViewModel.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

struct AppliesViewModel {
    
    enum Section {
        case main
    }
    
    let service: CountryServiceType!
    var dataSource: UICollectionViewDiffableDataSource<Section, Country>!
    
    init(service: CountryServiceType) {
        self.service = service
    }
    
    mutating func configureDataSource(for collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource<Section, Country>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlagCell.reuseIdentifier, for: indexPath) as! FlagCell
            
            cell.lblCountryName.text = item.name
            cell.lblFlag.text = item.flag
            return cell
        }
        do {
            let countries = try self.service.fetchAll()
            var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Country>()
            initialSnapshot.appendSections([.main])
            initialSnapshot.appendItems(countries, toSection: .main)
            dataSource.apply(initialSnapshot)
        } catch {
            print(error.localizedDescription)
        }
    }
}
