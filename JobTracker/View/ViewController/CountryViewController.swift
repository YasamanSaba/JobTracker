//
//  CountryViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 7/1/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController, ViewModelSupportedViewControllers {
    
    // MARK: - ViewModel
    var viewModel: CountryViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var txtCountryName: UITextField!
    @IBOutlet weak var txtCountryFlag: UITextField!
    @IBOutlet weak var colCountries: UICollectionView!
    
    // MARK: - Actions
    @IBAction func add(_ sender: Any) {
        guard let name = txtCountryName.text, let flag = txtCountryFlag.text else {
            showAlert(text: "Please fill all the fields.")
            return
        }
        if name == "" || flag == "" {
            showAlert(text: "Please fill all the fields.")
            return
        }
        viewModel.add(name: name, flag: flag)
        txtCountryName.text = ""
        txtCountryFlag.text = ""
    }
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.configure(collectionView: colCountries)
        txtCountryName.delegate = self
        txtCountryFlag.delegate = self
        txtCountryName.addTarget(self, action: #selector(onTxtCountryChanged), for: .allEditingEvents)
        txtCountryFlag.accessibilityIdentifier = "Flag"
    }

    func showAlert(text: String) {
        let alertController = UIAlertController(title: "Warning!", message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func onTxtCountryChanged() {
        viewModel.filter(by: txtCountryName.text ?? "")
    }
}

extension CountryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.accessibilityIdentifier == "Flag" {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 1
        }
        else {
            return true
        }
    }
}
extension CountryViewController: CountryViewModelDelegate {
}
