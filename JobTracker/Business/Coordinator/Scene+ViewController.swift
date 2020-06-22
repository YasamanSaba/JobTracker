//
//  Scene+ViewController.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/22/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

extension Scene {
    func viewController() -> UIViewController {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        switch self {
        case .tag:
            let storyboard = UIStoryboard(name: "Tag", bundle: nil)
            let viewController = storyboard.instantiateViewController(identifier: TagViewController.reuseIdentifier) as TagViewController
            let service = TagService(context: context)
            let viewModel = TagViewModel(service: service)
            viewController.viewModel = viewModel
            return viewController
        case .reminder(let reminderable):
            let storyboard = UIStoryboard(name: "Reminder", bundle: nil)
            let viewController = storyboard.instantiateViewController(identifier: ReminderViewController.reuseIdentifier) as ReminderViewController
            let service = ReminderService(context: context)
            let viewModel = ReminderViewModel(subject: reminderable, service: service)
            viewController.viewModel = viewModel
            return viewController
        }
    }
}
