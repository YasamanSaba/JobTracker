//
//  CoordinatorSupportedViewModel.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/23/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

protocol CoordinatorSupportedViewModel {
    associatedtype ViewModelDelegate
    var coordinator: CoordinatorType! {get set}
    var delegate: ViewModelDelegate? {get set}
}

protocol ViewModelDelegate: class {
    func error(text: String)
}
extension ViewModelDelegate where Self: UIViewController {
    func showAlert(text: String) {
        let alertController = UIAlertController(title: "Warning!", message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.show(alertController, sender: self)
    }
    func error(text:String) {
        showAlert(text: text)
    }
}
