//
//  AppDelegate.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 24/03/2020.
//  Copyright © 2020 Sune Kristian Jakobsen. All rights reserved.
//

import UIKit
import WatchConnectivity
import AudioToolbox
import SwiftUI
import CoreData
import UserNotifications
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    //var dataModel = DataModel()
    let phoneWatchConnectionService = PhoneWatchConnectionService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")

        AnalyticsHelper.configureFirebase()
        FirestoreHelper.shared.initializeFirestore()

        // Override point for customization after application launch.
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        PhoneSettings.shared.checkAndSetDefaultSettingValues()
        IntroProgressTracker.shared.updateWatchAppInstalledStatus()
        
        let center = UNUserNotificationCenter.current()
        UNUserNotificationCenter.current().delegate = self
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Notification permission granted!")
            } else {
                print("Notification permission denied!")
                if let error = error {
                    print("Error requesting notification permissions: \(error)")
                }
            }
        }
        
        setupNavigationColors()
        UISwitch.appearance().onTintColor = UIColor(named: "TopFadeColor")
        
        return true
    }
    
    fileprivate func setupNavigationColors() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "TopFadeColor") // Replace with your color
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.white)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.white)]

        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        //UINavigationBar.appearance().tintColor is not set here, since is is set different places in the code using .accentColor
       
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .sound])
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

    
    // MARK: WC Session deligate code
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {// this should be moved to background as shown below, to prevent the
            // app from freezing, but currently that has too low return on investment.
           // self.start()
            print("userInfo .. \(userInfo)")
            self.phoneWatchConnectionService.handleUserInfo(userInfo: userInfo,  persistentContainer: self.persistentContainer)
        }
        
        
        
        /*
        persistentContainer.performBackgroundTask { context in
            // This context is a private, background context
            self.phoneWatchConnectionService.handleUserInfo(userInfo: userInfo, context: context)
            
            // If there are changes in context, save them
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Handle the error appropriately
                    print("Failed to save in background context: \(error)")
                }
            }
            
            // If you need to update the UI after saving, make sure to dispatch that on the main thread
            DispatchQueue.main.async {
                // Update the UI here, if necessary
            }
        }*/
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        IntroProgressTracker.shared.updateWatchAppInstalledStatus()
        
        if session.isWatchAppInstalled {
            PhoneSettings.shared.sendSettingsToWatch()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // no action
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    
    // MARK: data persistence
    lazy var persistentContainer: NSPersistentContainer = {
        return CoreDataManager.shared.persistentContainer
    }()
}


