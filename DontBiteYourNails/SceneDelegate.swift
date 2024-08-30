//
//  SceneDelegate.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 24/03/2020.
//  Copyright © 2020 Sune Kristian Jakobsen. All rights reserved.
//

import UIKit
import SwiftUI
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate, ObservableObject {

    var window: UIWindow?
    var coreDataManager = CoreDataManager.shared
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        coreDataManager.setupPersistentContainer()
        let contentView = ContentView()
            .environment(\.managedObjectContext, coreDataManager.persistentContainer.viewContext)
    
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            
            window.makeKeyAndVisible()
        }
        
    }
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataManager.shared.saveContext()
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        print("Entered Background!")
        // Check if the timer is running
        if (PhoneRecordingService.shared.timer != nil) {
            print("Scheduling notification")
            scheduleBackgroundNotification()
        }
    }

    func navigateToPage(){
        if USER_DEFAULTS.bool(forKey: FROMSIGNUP) {
            let model : SignUpCompleteFlowModel = SignUpCompleteViewModel.shared.fetchDataAsLocally()
            
            switch model.userComes {

            case signUpTypeName.createSignup.rawValue:
                introProgressTracker.fromWhereToNavigate = signUpTypeName.createSignup.rawValue
                
            case signUpTypeName.stateSignup.rawValue:
                introProgressTracker.fromWhereToNavigate = signUpTypeName.stateSignup.rawValue
             
            case signUpTypeName.habitSignup.rawValue:
                introProgressTracker.fromWhereToNavigate = signUpTypeName.habitSignup.rawValue
                
            case signUpTypeName.finishSignup.rawValue:
                introProgressTracker.fromWhereToNavigate = signUpTypeName.finishSignup.rawValue
                
            case signUpTypeName.reminderSignup.rawValue:
                introProgressTracker.fromWhereToNavigate = signUpTypeName.reminderSignup.rawValue
                                
            default:
                break
            }
            
        }else{
            if let uID = USER_DEFAULTS.value(forKey: USERID) as? String, Auth.auth().currentUser?.uid == uID{
                IntroProgressTracker.shared.isUserLoggedIn = true
                
            }else{
                IntroProgressTracker.shared.isUserLoggedIn = false
            }
        }
    }

    func scheduleBackgroundNotification() {
        let content = UNMutableNotificationContent()
        content.title = "App is in Background!"
        content.body = "Your app has gone to the background which means it has stopped recording. Open it to resume recording."
        content.sound = UNNotificationSound.defaultCritical

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "backgroundNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

}

