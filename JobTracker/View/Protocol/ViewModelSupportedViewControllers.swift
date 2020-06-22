//
//  ViewModelSupportedViewControllers.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/22/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

protocol ViewModelSupportedViewControllers {
    associatedtype ViewModeType
    var viewModel: ViewModeType! {get set}
}

extension ViewModelSupportedViewControllers where Self:UIViewController {
    static var reuseIdentifier: String {
        NSStringFromClass(Self.self).components(separatedBy: ".")[1]
    }
}
