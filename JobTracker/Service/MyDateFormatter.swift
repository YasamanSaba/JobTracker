//
//  MyDateFormatter.swift
//  JobTracker
//
//  Created by Yasaman Farahani Saba on 7/15/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

struct MyDateFormatter {
    static let shared = MyDateFormatter()
    private init() {}
    // MARK: - Functions -
    func passedTime(from date: Date) -> String {
        var result = ""
        var hasYear = false
        var hasMonth = false
        let startOfDay = Calendar.current.startOfDay(for: date)
        let todayStartOfDay =  Calendar.current.startOfDay(for: Date())
        guard startOfDay != todayStartOfDay else {
            return "TODAY"
        }
        let components = Calendar.current.dateComponents([.year, .month, .day], from: startOfDay, to: Date())
        if let year = components.year, year > 0 {
            if year == 1 {
                result = "1 year"
            } else {
                result = "\(year) years"
            }
            hasYear = true
        }
        if let month = components.month, month > 0 {
            if month == 1 {
                result = result + (hasYear ? " & 1 month" : " 1 month")
            } else {
                result = result + (hasYear ? " & \(month) months" : " \(month) months")
            }
            hasMonth = true
        }
        if let day = components.day, day > 0 {
            if day == 1 {
                result = result + (hasMonth ? " & 1 day" : hasYear ? " & 1 day" : "1 day")
            } else {
                result = result + (hasMonth ? " & \(day) days" : hasYear ? " & \(day) days" : "\(day) days")
            }
        }
        if result.count > 0 {
            result += " ago"
        }
        return result
    }
    func remainTime(to date: Date) -> String {
        var result = ""
        let todayEndTime = Calendar.current.startOfDay(for: Date())
        let endTime = Calendar.current.startOfDay(for: date)
        let components = Calendar.current.dateComponents([.day], from: endTime, to: todayEndTime)
            guard todayEndTime != endTime else {
                return  "(TODAY)"
            }
            if let day = components.day, day < 0 {
                if day == -1 {
                    result = "(1 day left)"
                } else {
                    result = "(\(-day) days left)"
                }
            }
        return result
    }
}
