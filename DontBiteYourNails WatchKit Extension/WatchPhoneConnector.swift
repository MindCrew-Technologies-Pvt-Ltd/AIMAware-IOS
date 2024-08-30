//
//  WatchPhoneConnector.swift
//  DontBiteYourNails WatchKit Extension
//
//  Created by Sune Kristian Jakobsen on 29/07/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import UserNotifications


class WatchPhoneConnector: NSObject, ObservableObject, WCSessionDelegate {
    private static let sharedInstance = WatchPhoneConnector()
    
    let settings = WatchSettings.shared
    
    let device = WKInterfaceDevice.current().model
    
    var getReminderNotification = [UNNotificationTrigger]()
    
    static var shared: WatchPhoneConnector {
        return sharedInstance
    }
    
    
    func awake() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated && session.isReachable {
            // The session is active, and the iPhone is reachable.
            // You can now initiate data transfer using `transferUserInfo(_:userInfo:)`.
        }
    }
    
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        // Process the received data here
        print("applicationContext >>>>>>>>>>>>>>>>>>>>>>>>>")
        print("applicationContext \(applicationContext[SharedConstants.reminderNotificationKey])")
        if let recordFullSession = applicationContext[SharedConstants.recordFullSessionKey] as? Bool {
            settings.recordFullSession = recordFullSession
        }
        
        if let alertsOn = applicationContext[SharedConstants.alertsOn] as? Bool {
            settings.alertsOn = alertsOn
        }
        
        if let includeSecondaryAlert = applicationContext[SharedConstants.includeSecondaryAlert] as? Bool {
            settings.includeSecondaryAlert = includeSecondaryAlert
        }
        
        if let developerSettings = applicationContext[SharedConstants.developerSettings] as? Bool {
            settings.developerSettings = developerSettings
        }
        
        if let userHeight = applicationContext[SharedConstants.userHeight] as? Double {
            settings.userHeight = userHeight
        }
        
        if let alertDelay = applicationContext[SharedConstants.alertDelayKey] as? Double {
            settings.alertDelay = alertDelay
        }
        
        if let getReminderNotification = applicationContext[SharedConstants.reminderNotificationKey] as? [[String:Any]] {
            settings.reminderNotification = getReminderNotification
            if settings.reminderNotification.count  > 0 {
                sendNotification(triggerArr: settings.reminderNotification)
            }
        }
        
        if let deleteReminderNotification = applicationContext[SharedConstants.deleteNotificationKey] as? [String:Any] {
            settings.deleteReminderNotification = deleteReminderNotification
            deleteNotification(trigger: settings.deleteReminderNotification)
        }
        /*settings.reminderNotification = applicationContext[SharedConstants.reminderNotificationKey] as? [[String:Any]] ?? [[:]]
        print("222 \(settings.reminderNotification.count)")
        print("333 \(settings.reminderNotification)")*/
        
        
        

        
        /*if let getTimeNotification = applicationContext[SharedConstants.timeNotificationKey] as? String {
            if getTimeNotification != "" {
                settings.timeNotification = getTimeNotification
                if let getWeekendNotification = applicationContext[SharedConstants.weekendNotificationKey] as? String {
                    settings.weekendNotification = getWeekendNotification
                    print("First delete notification")
                    deleteNotification(time: getTimeNotification, weekend: getWeekendNotification)
                }
            }
        }*/
        
        if let persistentAlert = applicationContext[SharedConstants.persistentAlert] as? Bool {
            settings.persistentAlert = persistentAlert
        }
        
        if let areaSensitivities = applicationContext[SharedConstants.areaSensitivities] as?[String: Double] {
            settings.areaSensitivities = areaSensitivities
        }
        
        if let useSpecificAlerts = applicationContext[SharedConstants.useSpecificAlerts] as? Bool {
            settings.useSpecificAlerts = useSpecificAlerts
        }
        
        if let observationDelay = applicationContext[SharedConstants.observationDelay] as? Double {
            settings.observationDelay = observationDelay
        }
    }
    
    func sendNotification(triggerArr: [[String: Any]]){
        CustomNotification.shared.callNotificationForWatch(triggerArr: triggerArr)
    }
    
    func deleteNotification(trigger: [String: Any]){
        CustomNotification.shared.cancelNotification(trigger: trigger)
    }
    
    func sendDataToiPhone(data: [String: Any]) {
        var dataToSend = data
        dataToSend[SharedConstants.deviceId] = self.device // for now I'm using device model as device id.
        WCSession.default.transferUserInfo(dataToSend)
    }
    
}

