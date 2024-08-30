//
//  NotificationService.swift
//  DontBiteYourNails WatchKit Extension
//
//  Created by Sune Kristian Jakobsen on 27/07/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI
import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    
    func cancelOneHourNotification() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func scheduleOneHourNotification() {
        setupNotificationActionsAndCategoriesRenew()
        
        let content = UNMutableNotificationContent()
        content.title = "You session expires soon"
        content.body = "Renew if you want it to continue"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "SESSION_EXPIRY"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3510, repeats: false)// 3540. Consider 3510 to allow for small delay
        let request = UNNotificationRequest(identifier: "1hourWarning", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                //WKInterfaceDevice.current().play(.failure)
                print("Error sending one hour noticifation notification: \(error)")
            } else {
                //WKInterfaceDevice.current().play(.success)
                print("One hour notification sent successfully.")
            }
        }
    }
    
    func setupNotificationActionsAndCategoriesRenew() {
        let renewAction = UNNotificationAction(identifier: "RENEW_ACTION",
                                               title: "Renew Session",
                                               options: .foreground)
        
        let sessionCategory = UNNotificationCategory(identifier: "SESSION_EXPIRY",
                                                     actions: [renewAction],
                                                     intentIdentifiers: [],
                                                     options: [])

        UNUserNotificationCenter.current().setNotificationCategories([sessionCategory])
    }
    
    
    func alertNotification() { // unused due to annoying 15 second delay from trigger until shown. 
        setupNotificationActionsAndCategoriesOpenApp()
        
        
        let content = UNMutableNotificationContent()
        content.title = "Hand near head?"
        content.body = "Oh no!"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "OPEN_APP"

       
        let request = UNNotificationRequest(identifier: "alertNotification", content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                //WKInterfaceDevice.current().play(.failure)
                print("Error sending alert notification: \(error)")
            } else {
                //WKInterfaceDevice.current().play(.success)
                print("Alert notification sent successfully.")
            }
        }
    }
    
    
    func setupNotificationActionsAndCategoriesOpenApp() {
        let openAppAction = UNNotificationAction(identifier: "OPEN_APP",
                                               title: "Open app",
                                               options: .foreground)
        
        let sessionCategory = UNNotificationCategory(identifier: "OPEN_APP",
                                                     actions: [openAppAction],
                                                     intentIdentifiers: [],
                                                     options: [])

        UNUserNotificationCenter.current().setNotificationCategories([sessionCategory])
    }
}

