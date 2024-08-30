//
//  HostingController.swift
//  DontBiteYourNails WatchKit Extension
//
//  Created by Sune Kristian Jakobsen on 24/03/2020.
//  Copyright © 2020 Sune Kristian Jakobsen. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<ContentView>, WKExtendedRuntimeSessionDelegate {
    var appSessionService = AppSessionService.shared
    
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        print("Session started")
    // Track when your session starts.
    }

    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
    // Finish and clean up any tasks before the session ends.
        print("Session extended")
    }

    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        appSessionService.endSesion()
        print("Session endedd")
     // Track when your session ends.
        // Also handle errors here.
    }
    


    
    override var body: ContentView {
        
        return ContentView(controller: self)
    }
    
    
    var runtimeSession = WKExtendedRuntimeSession();

//    override init() {
//        super.init()
//        awake()
//    }
    


    func awake() {

        //setupWKExtendedSessionInterface(with: context)

        // Create the session and obtain the workout builder.
        /// - Tag: CreateWorkout
        runtimeSession = WKExtendedRuntimeSession()
        runtimeSession.delegate = self
        runtimeSession.start()
    }
    
    
    func endSession() {
        runtimeSession.invalidate()
        
    }

}
