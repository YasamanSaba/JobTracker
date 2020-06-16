//
//  ReminderViewModel.swift
//  JobTracker
//
//  Created by Sam Javadizadeh on 6/16/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import UserNotifications

struct ReminderViewModel {
    let subject: Reminderable
    let service: ReminderService
    
    init(subject: Reminderable, service: ReminderService) {
        self.subject = subject
        self.service = service
    }
    
    func setReminder(date: Date, message: String, success: @escaping (Bool)-> Void) {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year,.day,.month,.hour,.minute,.second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let content = UNMutableNotificationContent()
        var title = "!"
        if let _ = subject as? Interview {
            title = " your interview!"
        }
        if let task = subject as? Task {
            title = " to do \(task.title ?? "your task")"
        }
        content.title = "Don't forget\(title)"
        content.body = message
        content.sound = .defaultCritical
        let reminderNotificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: reminderNotificationID, content: content, trigger: trigger)
        
        
        UNUserNotificationCenter.current().add(request){ error in
            if error != nil {
                success(false)
                return
            }
            do {
                try self.service.add(date: date, message: message, notificationID: reminderNotificationID)
                success(true)
            } catch {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminderNotificationID])
                success(false)
            }
        }
    }
}
