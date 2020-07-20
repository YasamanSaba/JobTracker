//
//  ReminderViewModel.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import UserNotifications

struct ReminderViewModel: CoordinatorSupportedViewModel {
    // MARK: - Properties -
    weak var delegate: ReminderViewModelDelegate?
    var coordinator: CoordinatorType!
    let subject: Reminderable
    let service: ReminderServiceType
    // MARK: - Initializer -
    init(subject: Reminderable, service: ReminderServiceType) {
        self.subject = subject
        self.service = service
    }
    // MARK: - Functions -
    func getPermision() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) {_,_ in
            
        }
    }
    func setReminder(date: Date, message: String, success: @escaping (Bool)-> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) else {
                success(false)
                return
            }
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year,.day,.month,.hour,.minute,.second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let content = UNMutableNotificationContent()
            var title = "!"
            if let _ = self.subject as? Interview {
                title = " your interview!"
            }
            if let task = self.subject as? Task {
                title = " to do \(task.title ?? "your task")"
            }
            content.title = "Don't forget\(title)"
            content.body = message
            content.sound = .defaultCritical
            let reminderNotificationID = UUID().uuidString
            let request = UNNotificationRequest(identifier: reminderNotificationID, content: content, trigger: trigger)
            
            
            center.add(request){ error in
                if error != nil {
                    success(false)
                    return
                }
                do {
                    let _ = try self.service.add(date: date, message: message, notificationID: reminderNotificationID, for: self.subject )
                    success(true)
                } catch {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminderNotificationID])
                    success(false)
                }
            }
        }
    }
}
