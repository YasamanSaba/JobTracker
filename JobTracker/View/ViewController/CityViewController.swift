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
        if let cityName = txtCity.text {
            viewModel.add(name:cityName)
        }
        txtCity.text = ""
    }
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start(collectionView: colCities)
        let countryInfo = viewModel.getCountry()
        lblCountryName.text = countryInfo.0
        lblCountryFlag.text = countryInfo.1
        txtCity.addTarget(self, action: #selector(onTxtCountryChanged), for: .allEditingEvents)
    }
    // MARK: - Functions
    @objc func onTxtCountryChanged() {
        viewModel.filter(by: txtCity.text ?? "")
    }
}
// MARK: - Extension
extension CityViewController: CityViewModelDelegate {
}
