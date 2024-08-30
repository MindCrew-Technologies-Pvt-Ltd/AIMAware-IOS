//
//  WatchSettings.swift
//  DontBiteYourNails WatchKit Extension
//
//  Created by Sune Kristian Jakobsen on 28/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import WatchKit
import UserNotifications

class WatchSettings: ObservableObject {
    static let shared = WatchSettings()
    
    @Published var isUserLoggedIn = false
    @Published var goToSignUpPage: Bool = false
    @Published var isShowingBipAndViewAfterDelay = false
    @Published var activeAlertDurationSeconds = 120.0
    
    @Published var safeUserHeight = 1.65
    
    @Published var userHeight: Double = UserDefaults.standard.double(forKey: SharedConstants.userHeight) {
        didSet {
            UserDefaults.standard.set(userHeight, forKey: SharedConstants.userHeight)
            if userHeight > 0.3 {
                safeUserHeight = userHeight
            } else {
                safeUserHeight = 1.65
            }
        }
    }    
    @Published var observationDelay: Double = UserDefaults.standard.double(forKey: SharedConstants.observationDelay) {
        didSet {
            UserDefaults.standard.set(observationDelay, forKey: SharedConstants.observationDelay)
        }
    }

    
    @Published var developerSettings: Bool = UserDefaults.standard.bool(forKey: SharedConstants.developerSettings) {
        didSet {
            UserDefaults.standard.set(developerSettings, forKey: SharedConstants.developerSettings)
        }
    }
    
    @Published var includeSecondaryAlert: Bool = UserDefaults.standard.bool(forKey: SharedConstants.includeSecondaryAlert) {
        didSet {
            UserDefaults.standard.set(includeSecondaryAlert, forKey: SharedConstants.includeSecondaryAlert)
        }
    }
    
    @Published var alertsOn: Bool = UserDefaults.standard.object(forKey: SharedConstants.alertsOn) as? Bool ?? true {
        didSet {
            UserDefaults.standard.set(alertsOn, forKey: SharedConstants.alertsOn)
        }
    }
    
    @Published var recordFullSession: Bool = UserDefaults.standard.bool(forKey: SharedConstants.recordFullSessionKey) {
        didSet {
            UserDefaults.standard.set(recordFullSession, forKey: SharedConstants.recordFullSessionKey)
        }
    }
    
    @Published var alertDelay: Double = UserDefaults.standard.double(forKey: SharedConstants.alertDelayKey) {
        didSet {
            UserDefaults.standard.set(alertDelay, forKey: SharedConstants.alertDelayKey)
        }
    }
    
    @Published var reminderNotification: [[String: Any]] = []
    
    @Published var deleteReminderNotification: [String: Any] = (UserDefaults.standard.dictionary(forKey: SharedConstants.deleteNotificationKey) ?? [:]) {
        didSet {
            UserDefaults.standard.set(deleteReminderNotification, forKey: SharedConstants.deleteNotificationKey)
        }
    }
    
    @Published var persistentAlert: Bool = UserDefaults.standard.object(forKey: SharedConstants.persistentAlert)  as? Bool ?? true {
        didSet {
            UserDefaults.standard.set(persistentAlert, forKey: SharedConstants.persistentAlert)
            //WKInterfaceDevice.current().play(.success)
        }
    }
    
    @Published var areaSensitivities: [String: Double] = (UserDefaults.standard.dictionary(forKey: SharedConstants.areaSensitivities) as? [String: Double] ?? [:]) {
        didSet {
            UserDefaults.standard.set(areaSensitivities, forKey: SharedConstants.areaSensitivities)
        }
    }
    
    @Published var useSpecificAlerts: Bool = UserDefaults.standard.bool(forKey: SharedConstants.useSpecificAlerts) {
        
        didSet {
            print("watch setting useSpecificAlerts")
            UserDefaults.standard.set(useSpecificAlerts, forKey: SharedConstants.useSpecificAlerts)
        }
    }

}
