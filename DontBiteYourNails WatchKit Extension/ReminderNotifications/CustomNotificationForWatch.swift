//
//  CustomNotificationForWatch.swift
//  AImAware WatchKit App
//
//  Created by Suyog on 22/05/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI
import Foundation
import UserNotifications

enum AppWeekends : String {
    case Sunday
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday

}
class CustomNotification{
    static let shared = CustomNotification()
    var triggerArr = [NotificationModel]()
    
    func cancelNotification(trigger: [String: Any]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["stringWatchIdentifier_\(trigger["Hour"] as? Int ?? 0)_\(trigger["Minute"] as? Int ?? 0)_\(trigger["WeekDay"] as? Int ?? 0)"])
    }
    
    func callNotificationForWatch(triggerArr: [[String: Any]]){
        for trigger in triggerArr {
            // Create the content of the notification
            let content = UNMutableNotificationContent()
            content.title = "AlmAware Watch App"
            content.body = "Watch app reminder comes"

            // Create the request
            //let uuidString = UUID().uuidString
            let addTrigger = UNCalendarNotificationTrigger(dateMatching: DateComponents.triggerFor(hour: trigger["Hour"] as? Int ?? 0, minute: trigger["Minute"] as? Int ?? 0, weekday: trigger["WeekDay"] as? Int ?? 0), repeats: true)
            let request = UNNotificationRequest(identifier: "stringWatchIdentifier_\(trigger["Hour"] as? Int ?? 0)_\(trigger["Minute"] as? Int ?? 0)_\(trigger["WeekDay"] as? Int ?? 0)",content: content, trigger: addTrigger)

            // Schedule the request with the system.
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
                print("trigger request \(request)")
               if error != nil {
                   
                  // Handle any errors.
               }
            }
        }
    }
    
    //MARK: - Notification Methods
    func setNotificationOnTimers(userDetail: [[String: Any]], completion: @escaping(_ triggerArr: [NotificationModel]) -> ()){
        triggerArr = [NotificationModel]()
        for i in 0 ..< userDetail.count {
            let dict = userDetail[i]
            if dict["ReminderStatus"] as? Bool ?? false == true{
                getWeekendReminder(weekendReminderStr: dict["WeekendReminder"] as? String ?? "") { weekDay in
                    self.getTimeReminder(timeReminderStr: dict["Reminder"] as? String ?? "") { hour,minute  in
                        let model : NotificationModel = NotificationModel(weekend: dict["WeekendReminder"] as? String ?? "", time: dict["Reminder"] as? String ?? "", trigerTime: UNCalendarNotificationTrigger(dateMatching: DateComponents.triggerFor(hour: hour, minute: minute, weekday: weekDay), repeats: true))
                        self.triggerArr.append(model)
                        
                    }
                }
            }
        }
        completion(triggerArr)
    }
    
    func getWeekendReminder(weekendReminderStr: String, completion: @escaping(_ weekDay: Int) -> ()){
        let split = weekendReminderStr.split(separator: " ")
        let weekendStr = String(split.suffix(1).joined(separator: [" "]))
        getIntValueAccToWeekend(weekendValue: weekendStr) { weekDay in
            completion(weekDay)
        }
        
    }
    
    func getIntValueAccToWeekend(weekendValue: String, completion: @escaping(_ weekDay: Int) -> ()) {
        switch weekendValue {
        case AppWeekends.Sunday.rawValue:
            completion(1)
        case AppWeekends.Monday.rawValue:
            completion(2)
        case AppWeekends.Tuesday.rawValue:
            completion(3)
        case AppWeekends.Wednesday.rawValue:
            completion(4)
        case AppWeekends.Thursday.rawValue:
            completion(5)
        case AppWeekends.Friday.rawValue:
            completion(6)
        case AppWeekends.Saturday.rawValue:
            completion(7)
        default:
            completion(0)
        }
    }
    
    func getTimeReminder(timeReminderStr: String, completion: @escaping(_ hour: Int, _ minute: Int) -> ()) {
        let split = timeReminderStr.split(separator: ":")
        let colonStr = split[1]
        let amPm = colonStr.suffix(2)
        let minStr = colonStr.prefix(2)
        
        if amPm == "PM"{
            completion(getIntValueAccToTime(timeValue: String(split[0])), Int(minStr) ?? 0)
        }else{
            completion(Int(split[0]) ?? 0, Int(minStr) ?? 0)
        }
    }
    
    func getIntValueAccToTime(timeValue: String) -> Int {
        switch timeValue {
        case "1":
            return 13
        case "2":
            return 14
        case "3":
            return 15
        case "4":
            return 16
        case "5":
            return 17
        case "6":
            return 18
        case "7":
            return 19
        case "8":
            return 20
        case "9":
            return 21
        case "10":
            return 22
        case "11":
            return 23
        case "12":
            return 12
        default:
            return 0
        }
    }
}
extension DateComponents {
    static func triggerFor(hour: Int, minute: Int, weekday: Int) -> DateComponents {
      var component = DateComponents()
      component.calendar = Calendar.current
      component.hour = hour
      component.minute = minute
      component.weekday = weekday
      return component
   }
}
struct NotificationModel{
    var weekend : String?
    var time: String?
    var trigerTime: UNNotificationTrigger?
    
    init(weekend: String? = nil, time: String? = nil, trigerTime: UNNotificationTrigger? = nil) {
        self.weekend = weekend
        self.time = time
        self.trigerTime = trigerTime
    }
}

struct NotificationDateModel{
    var weekend : Int?
    var hour: Int?
    var min: Int?
    
    init(weekend: Int? = nil, hour: Int? = nil, min: Int? = nil) {
        self.weekend = weekend
        self.hour = hour
        self.min = min
    }
}
