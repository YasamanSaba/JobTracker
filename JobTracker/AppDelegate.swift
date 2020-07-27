//
//  AppDelegate.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 6/6/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var appCoordinator: CoordinatorType!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DataInitializer.importInitialData()
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let applyObjectIdString = userInfo["ApplyObjectId"] as? String,
            let subjectIdString = userInfo["SubjectObjectId"] as? String,
            let type = userInfo["Type"] as? String,
            let applyObjectIdURL = URL(string: applyObjectIdString) ,
            let subjectIdURL = URL(string: subjectIdString),
            let applyObjectID = persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: applyObjectIdURL),
            let subjectObjectID = persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: subjectIdURL)
        {
            
            
            let request: NSFetchRequest<Apply> = Apply.fetchRequest()
            let predicate = NSPredicate(format: "self == %@", applyObjectID)
            request.predicate = predicate
            do {
                guard let apply = try persistentContainer.viewContext.fetch(request).first else { return }
                switch type {
                case "Interview":
                    let interviewRequest: NSFetchRequest<Interview> = Interview.fetchRequest()
                    let interviewPredicate = NSPredicate(format: "self == %@", subjectObjectID)
                    interviewRequest.predicate = interviewPredicate
                    guard let interview = try persistentContainer.viewContext.fetch(interviewRequest).first else { return }
                    appCoordinator.push(scene: .apply(apply), sender: ((appCoordinator.window.rootViewController! as! UITabBarController).viewControllers![0] as! UINavigationController).viewControllers[0])
                    appCoordinator.push(scene: .interview(apply, interview), sender: ((appCoordinator.window.rootViewController! as! UITabBarController).viewControllers![0] as! UINavigationController).viewControllers[0])
                case "Task":
                    let taskRequest: NSFetchRequest<Task> = Task.fetchRequest()
                    let taskPredicate = NSPredicate(format: "self == %@", subjectObjectID)
                    taskRequest.predicate = taskPredicate
                    guard let task = try persistentContainer.viewContext.fetch(taskRequest).first else { return }
                    appCoordinator.push(scene: .apply(apply), sender: ((appCoordinator.window.rootViewController! as! UITabBarController).viewControllers![0] as! UINavigationController).viewControllers[0])
                    appCoordinator.push(scene: .task(apply, task), sender: ((appCoordinator.window.rootViewController! as! UITabBarController).viewControllers![0] as! UINavigationController).viewControllers[0])
                default:
                    return
                }
            } catch {
                return
            }
        }
        completionHandler()
    }
    

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "JobTracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

