//
//  CustomNotification.swift
//  AImAware
//
//  Created by Suyog on 16/05/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI
import Foundation
import UserNotifications
class CustomNotification{
    static let shared = CustomNotification()
    
    func cancelNotification(time: String?, weekend: String?) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["stringIdentifier_\(time ?? "")_\(weekend ?? "")"])
    }
    
    func callNotification(triggerArr: [NotificationModel]){
        for trigger in triggerArr {
            // Create the content of the notification
            let content = UNMutableNotificationContent()
            content.title = "AlmAware"
            content.body = "App reminder comes"
            content.sound = UNNotificationSound(named: UNNotificationSoundName("alert.caf"))

            // Create the request
            //let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: "stringIdentifier_\(trigger.time ?? "")_\(trigger.weekend ?? "")",content: content, trigger: trigger.trigerTime)

            // Schedule the request with the system.
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
                print("request \(request)")
               if error != nil {
                  // Handle any errors.
               }
            }
        }
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
