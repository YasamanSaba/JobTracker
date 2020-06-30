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
        
        // MARK: - Context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // MARK: - Coordinator
        let coordinator = (UIApplication.shared.delegate as! AppDelegate).appCoordinator
        
        switch self {
        case .tag(let onCompletion):
            let storyboard = UIStoryboard(name: "Tag", bundle: nil)
            let viewController = storyboard.instantiateViewController(identifier: TagViewController.reuseIdentifier) as TagViewController
            let service = TagService(context: context)
            let viewModel = TagViewModel(service: service,onCompletion: onCompletion)
            viewController.viewModel = viewModel
            return viewController
        case .reminder(let reminderable):
            let storyboard = UIStoryboard(name: "Reminder", bundle: nil)
            let viewController = storyboard.instantiateViewController(identifier: ReminderViewController.reuseIdentifier) as ReminderViewController
            let service = ReminderService(context: context)
            let viewModel = ReminderViewModel(subject: reminderable, service: service)
            viewController.viewModel = viewModel
            return viewController
        case .applies:
            let storyboard = UIStoryboard(name: "Apply", bundle: nil)
            let viewController = storyboard.instantiateViewController(identifier: AppliesViewController.reuseIdentifier) as AppliesViewController
            let countryService = CountryService(context: context)
            let applyService = ApplyService(context: context)
            let viewModel = AppliesViewModel(countryService: countryService, applyService: applyService)
            viewController.viewModel = viewModel
            
            let navController = UINavigationController(rootViewController: viewController)
            return navController
        case .notes:
            let storyboard = UIStoryboard(name: "Note", bundle: nil)
            let viewController = storyboard.instantiateViewController(identifier: NotesViewController.reuseIdentifier) as NotesViewController
            let viewModel = NotesViewModel(coordinator: coordinator)
            viewController.viewModel = viewModel
            let navController = UINavigationController(rootViewController: viewController)
            return navController
        case .note:
            let storyboard = UIStoryboard(name: "Note", bundle: nil)
            let viewController = storyboard.instantiateViewController(identifier: NoteViewController.reuseIdentifier) as NoteViewController
            //let viewModel = NoteViewModel()
            //viewController.viewModel = viewModel

            return viewController
        case .apply(let apply):
            let storyboard = UIStoryboard(name: "ApplyDetail", bundle: nil)
            let viewController = storyboard.instantiateViewController(identifier: ApplyViewController.reuseIdentifier) as ApplyViewController
            let applyService = ApplyService(context: context)
            let interviewService = InterviewService(context: context)
            let taskService = TaskService(context: context)
            let viewModel = ApplyViewModel(applyService: applyService, interviewService: interviewService, apply: apply, taskService: taskService)
            viewController.viewModel = viewModel
            return viewController
        case .newApply:
            let storyboard = UIStoryboard(name: "NewApply", bundle: nil)
            let viewController = storyboard.instantiateViewController(identifier: NewApplyViewController.reuseIdentifier) as NewApplyViewController
            let countryService = CountryService(context: context)
            let cityService = CityService(context: context)
            let applyService = ApplyService(context: context)
            let tagService = TagService(context: context)
            let viewModel = NewApplyViewModel(countryService: countryService, cityService: cityService, applyService: applyService, tagService: tagService)
            viewController.viewModel = viewModel
            return viewController
        case .company(let onComplete):
            let storyboard = UIStoryboard(name: "Company", bundle: nil)
            let viewController = storyboard.instantiateViewController(identifier: CompanyViewController.reuseIdentifier) as CompanyViewController
            let companyService = CompanyService(context: context)
            let viewModel = CompanyViewModel(companyService: companyService, onComplete: onComplete)
            viewController.viewModel = viewModel
            return viewController
        }
    }
}
