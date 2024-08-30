//
//  PhoneSettings.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 28/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import WatchConnectivity
import UserNotifications

class PhoneSettings: ObservableObject {
    
    static let shared = PhoneSettings()
    
    let config = Config.shared
        
    func updateAreaSensitivity(for area: String, value: Double) {
        areaSensitivities[area] = value
        // Update UserDefaults or any other storage mechanism here
    }
    
    init() {
        let sessionTypeString = UserDefaults.standard.string(forKey: SharedConstants.selectedSessionType) ?? SessionType.normalUse.rawValue
        self.selectedSessionType = SessionType(rawValue: sessionTypeString) ?? .developerSettings
        print("PhoneSettings initialized with session type: \(self.selectedSessionType)")
        
        /*let decoded  = USER_DEFAULTS.object(forKey: SharedConstants.reminderNotificationKey) as! Data
        getReminderNotification = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [UNNotificationTrigger] ?? [UNNotificationTrigger]()
        reminderNotification = getReminderNotification*/
    }

    @Published var selectedSessionType: SessionType {
        didSet {
            UserDefaults.standard.set(selectedSessionType.rawValue, forKey: SharedConstants.selectedSessionType)
        }
    }
    

    @Published var useSpecificAlerts: Bool = UserDefaults.standard.bool(forKey: SharedConstants.useSpecificAlerts) {
        didSet {
            print("phone setting useSpecificAlerts")
            updateUseSpecificAlerts(useSpecificAlerts)
        }
    }
    
    @Published var userHeight: Double = UserDefaults.standard.double(forKey: SharedConstants.userHeight) {
        didSet {
            updateUserHeight(userHeight)
        }
    }  
    
    @Published var areaSensitivities: [String: Double] = (UserDefaults.standard.dictionary(forKey: SharedConstants.areaSensitivities) as? [String: Double] ?? [:]) {
        didSet {
            updateAreaSensitivities(areaSensitivities)
        }
    }

    
    @Published var persistentAlert: Bool = UserDefaults.standard.bool(forKey: SharedConstants.persistentAlert) {
        didSet {
            updatePersistentAlert(persistentAlert)
        }
    }
    
    @Published var recordFullSession: Bool = UserDefaults.standard.bool(forKey: SharedConstants.recordFullSessionKey) {
        didSet {
            updateRecordFullSession(recordFullSession)
        }
    }
    
    @Published var developerSettings: Bool = UserDefaults.standard.bool(forKey: SharedConstants.developerSettings) {
        didSet {
            updateDeveloperSettings(developerSettings)
        }
    }
    
    @Published var alertsOn: Bool = UserDefaults.standard.bool(forKey: SharedConstants.alertsOn) {
        didSet {
            updateAlertsOn(alertsOn)
        }
    }
    
    @Published var includeSecondaryAlert: Bool = UserDefaults.standard.bool(forKey: SharedConstants.includeSecondaryAlert) {
        didSet {
            updateIncludeSecondaryAlert(includeSecondaryAlert)
        }
    }
    
    @Published var alertDelay: Double = UserDefaults.standard.double(forKey: SharedConstants.alertDelayKey) {
        didSet {
            updateAlertDelay(alertDelay)
        }
    }
    
    @Published var getReminderNotification: [[String: Any]] = []
    
    @Published var deleteReminderNotification: [String: Any] = (UserDefaults.standard.dictionary(forKey: SharedConstants.deleteNotificationKey) ?? [:]) {
        didSet {
            updateDeleteNotification(deleteReminderNotification)
        }
    }
    
    //@Published var deleteReminderNotification: [String: Any] = [:]
    
    @Published var observationDelay: Double = UserDefaults.standard.double(forKey: SharedConstants.observationDelay) {
        didSet {
            updateObservationDelay(observationDelay)
        }
    }
    
    @Published var autoRecord: Bool = UserDefaults.standard.bool(forKey: SharedConstants.autoRecord) {
        didSet {
            // not send to the watch because it doesn't need it.
        }
    }
    
    private var workItem: DispatchWorkItem?
    
    
    func updateUserHeight(_ newValue: Double) {
        UserDefaults.standard.set(newValue, forKey: SharedConstants.userHeight)
        delayedSendSettingsToWatch()
    }
    
    func updateAreaSensitivities(_ newValue: [String: Double]) {
        UserDefaults.standard.set(newValue, forKey: SharedConstants.areaSensitivities)
        delayedSendSettingsToWatch(delay: 2.0)
    }
    
    func updateDeleteNotification(_ newValue: [String: Any]) {
        UserDefaults.standard.set(newValue, forKey: SharedConstants.deleteNotificationKey)
        delayedSendSettingsToWatch(delay: 2.0)
    }
    
    func updateUseSpecificAlerts(_ newValue: Bool) {
        print("updateUseSpecificAlerts")
        UserDefaults.standard.set(newValue, forKey: SharedConstants.useSpecificAlerts)
        delayedSendSettingsToWatch()
    }
    
    func updatePersistentAlert(_ newValue: Bool) {
        UserDefaults.standard.set(newValue, forKey: SharedConstants.persistentAlert)
        delayedSendSettingsToWatch()
    }
    
    func updateDeveloperSettings(_ newValue: Bool) {
        UserDefaults.standard.set(newValue, forKey: SharedConstants.developerSettings)
        
        if(newValue) {
            delayedSendSettingsToWatch()
        } else {
            recordFullSession = false // turns off record if on. In any case updates phone
            observationDelay = 0.0
            alertsOn = true
            includeSecondaryAlert = false
        }
    }
    
    func updateAlertsOn(_ newValue: Bool) {
        print("alertsOn going to false \(newValue)")
        UserDefaults.standard.set(newValue, forKey: SharedConstants.alertsOn)
        delayedSendSettingsToWatch()
    }
    
    func updateIncludeSecondaryAlert(_ newValue: Bool) {
        UserDefaults.standard.set(newValue, forKey: SharedConstants.includeSecondaryAlert)
        delayedSendSettingsToWatch()
    }
    
    
    func updateRecordFullSession(_ newValue: Bool) {
        UserDefaults.standard.set(newValue, forKey: SharedConstants.recordFullSessionKey)
        delayedSendSettingsToWatch()
    }
    
    func updateAlertDelay(_ newValue: Double) {
        UserDefaults.standard.set(newValue, forKey: SharedConstants.alertDelayKey)
        delayedSendSettingsToWatch(delay: 2.0)
    }
        
    func updateReminderNotificationSetting(_ newValue: [[String: Any]]) {
        getReminderNotification = newValue
        delayedSendSettingsToWatch()
    }
    
    /*func deleteReminderNotificationSetting(_ newValue: [String: Any]) {
        delayedSendSettingsToWatch()
    }*/
    
    func updateObservationDelay(_ newValue: Double) {
        UserDefaults.standard.set(newValue, forKey: SharedConstants.observationDelay)
        delayedSendSettingsToWatch(delay: 2.0)
    }
    
    func checkAndSetDefaultSettingValues() {
        let defaults = UserDefaults.standard
        
        if let versionKey = defaults.object(forKey: SharedConstants.settingsVersionKey) as? Int {
            if  versionKey > 1 {
                defaults.set(nil, forKey: SharedConstants.settingsVersionKey)
            }
        }
        print(" default updateUseSpecificAlerts")

        if defaults.object(forKey: SharedConstants.settingsVersionKey) == nil {
            // This is the initial launch, set the default values
            defaults.set(false, forKey: SharedConstants.recordFullSessionKey)
            defaults.set(0, forKey: SharedConstants.alertDelayKey)
            defaults.set(false, forKey: SharedConstants.developerSettings)
            defaults.set(true, forKey: SharedConstants.persistentAlert)
            defaults.set(false, forKey: SharedConstants.useSpecificAlerts)
            defaults.set(0, forKey: SharedConstants.observationDelay)
            defaults.set(false, forKey: SharedConstants.includeSecondaryAlert)
            defaults.set(true, forKey: SharedConstants.alertsOn)
            
            // Mark the initial setup as for version 1
            defaults.set(1, forKey: SharedConstants.settingsVersionKey)
            delayedSendSettingsToWatch(delay: 2.0)
        }
        

        if (!config.showDeveloperSettingsOptions) {
            defaults.set(false, forKey: SharedConstants.developerSettings)
            defaults.set(false, forKey: SharedConstants.recordFullSessionKey) // goes back to false because developersettings are false
        }
    
        delayedSendSettingsToWatch()
    }
    
    /* Settings are send delayed to avoid sending many messages if there are many changes to settings.
     * Default delay is 0.1 sec, this is for automatic changes, for example when changes session type make
     * changes to many sessions at once. For manual slider changes, I set the delay to 2 secs.
     */
    func delayedSendSettingsToWatch(delay: Double = 0.1) {
        print("phone setting delayedSendSettingsToWatch")
        workItem?.cancel()
        
        // Create a new work item
        let newWorkItem = DispatchWorkItem { [self] in
            sendSettingsToWatch()
        }
        workItem = newWorkItem
        
        // Execute the work item after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: newWorkItem)
    }
    
    func sendSettingsToWatch() {
        //var getReminderNotification = [[String:Any]]()
        //var timeNotification = String()
        //var weekendNotification = String()
        /*if USER_DEFAULTS.object(forKey: SharedConstants.reminderNotificationKey) != nil {
            let decoded  = USER_DEFAULTS.object(forKey: SharedConstants.reminderNotificationKey) as! Data
            getReminderNotification = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [[String:Any]] ?? [[String:Any]]()
        }*/
        /*if USER_DEFAULTS.object(forKey: SharedConstants.timeNotificationKey) != nil && USER_DEFAULTS.object(forKey: SharedConstants.weekendNotificationKey) != nil{
            timeNotification = USER_DEFAULTS.object(forKey: SharedConstants.timeNotificationKey) as? String ?? ""
            weekendNotification = USER_DEFAULTS.object(forKey: SharedConstants.weekendNotificationKey) as? String ?? ""
        }
        print("phone setting sendSettingsToWatch")*/
        
        
        let context: [String: Any] = [
            SharedConstants.recordFullSessionKey: recordFullSession,
            SharedConstants.alertDelayKey: alertDelay,
            SharedConstants.reminderNotificationKey: getReminderNotification,
            SharedConstants.deleteNotificationKey: deleteReminderNotification,
            //SharedConstants.weekendNotificationKey: weekendNotification,
            SharedConstants.developerSettings: developerSettings,
            SharedConstants.persistentAlert: persistentAlert,
            SharedConstants.areaSensitivities: areaSensitivities,
            SharedConstants.useSpecificAlerts: useSpecificAlerts,
            SharedConstants.observationDelay: observationDelay,
            SharedConstants.includeSecondaryAlert: includeSecondaryAlert,
            SharedConstants.alertsOn: alertsOn,
            SharedConstants.userHeight: userHeight
        ]
        do {
            print(context)
            try WCSession.default.updateApplicationContext(context)
            
        } catch {
            print("Error updating application settings: \(error)")

        }
    }
    
    func updateAlertDelayDataToFB(){
        DatabaseManager.shared.updateDelay(delayData: [SharedConstants.alertDelayKey: alertDelay]) { status  in
            if status == 200 {
                AnalyticsHelper.logUpdateDelayEvent(key: "update_delay_value", value: SignUpCompleteViewModel.shared.getCurrentUserId() ?? "", delay: self.alertDelay)
                print("updated successfully")
            }
        }
    }
}
