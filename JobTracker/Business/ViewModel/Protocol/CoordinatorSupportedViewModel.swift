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
    func error(text:String)
    func deleteConfirmation(onComplete: @escaping (Bool) -> Void)
}
extension ViewModelDelegate where Self: UIViewController {
    func showAlert(text: String) {
        let alertController = UIAlertController(title: "Warning!", message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func error(text:String) {
        showAlert(text: text)
    }
    func deleteConfirmation(onComplete: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "Warning!", message: "Are you sure to delete?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            onComplete(true)
        }
        let noAction = UIAlertAction(title: "No", style: .default) { _ in
            onComplete(false)
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.show(alertController, sender: self)
    }
}
