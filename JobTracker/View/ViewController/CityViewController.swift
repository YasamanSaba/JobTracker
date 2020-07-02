//
//  CityViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/1/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class CityViewController: UIViewController, ViewModelSupportedViewControllers {
    
    // MARK: - ViewModel
    var viewModel: CityViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var lblCountryFlag: UILabel!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var colCities: UICollectionView!
    
    // MARK: - Actions
    @IBAction func add(_ sender: Any) {
        
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.configure(collectionView: colCities)
        let countryInfo = viewModel.getCountry()
        lblCountryName.text = countryInfo.0
        lblCountryFlag.text = countryInfo.1
        txtCity.addTarget(self, action: #selector(onTxtCountryChanged), for: .allEditingEvents)
    }

    @objc func onTxtCountryChanged() {
        viewModel.filter(by: txtCity.text ?? "")
    }
}
