//
//  AppCoordinator.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/22/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class AppCoordinator: CoordinatorType {
    
    let window: UIWindow!
    var tabBar: UITabBarController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    /// Start point of application UI
    /// Create `UITabBarController` and add tabs to it
    /// - Parameter tabs: tabs you want to include in the tab bar
    func start(by tabs: [Tab]) {
        tabBar = UITabBarController()
        var viewControllers: [UIViewController] = []
        tabs.forEach{ tab in
            switch tab {
            case .applies:
                let viewController = Scene.applies.viewController()
                viewController.title = "Applies"
                viewController.tabBarItem.image = UIImage(systemName: "doc.on.doc.fill")
                viewControllers.append(viewController)
            case .notes:
                let viewController = Scene.notes.viewController()
                viewController.title = "Notes"
                viewController.tabBarItem.image = UIImage(systemName: "bubble.left.and.bubble.right.fill")
                viewControllers.append(viewController)
            }
        }
        tabBar?.viewControllers = viewControllers
        window.rootViewController = tabBar
        tabBar?.selectedIndex = 0
        window?.makeKeyAndVisible()
    }
    
    func push(scene: Scene, sender: Any) {
        if let currentController = sender as? UIViewController, let navController = currentController.navigationController {
            let destController = scene.viewController()
            navController.pushViewController(destController, animated: true)
        }
    }
    
    func present(scene: Scene, sender: Any) {
        if let currentController = sender as? UIViewController {
            let destController = scene.viewController()
            currentController.present(destController, animated: true, completion: nil)
        }
    }
}
