//
//  AppSessionService.swift
//  DontBiteYourNails WatchKit Extension
//
//  Created by Sune Kristian Jakobsen on 30/07/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

class AppSessionService : ObservableObject{
    private static let sharedInstance = AppSessionService()
    
    static var shared: AppSessionService {
        return sharedInstance
    }
    
    let watchPhoneConnector = WatchPhoneConnector.shared
    
    var currentSessionId = UUID()
    
    func endSesion() {
        notifyiPhone(action: .end, isLeftHand: nil)
    }
    
    func renewSesion() {
        notifyiPhone(action: .renew, isLeftHand: nil)
    }

    
    func sessionAction(action: SessionActionEnum, isLeftHand: Bool) {
        if action == .start {
            currentSessionId = UUID()
        }
        
        notifyiPhone(action: action, isLeftHand: isLeftHand)
    }
    
    fileprivate func notifyiPhone(action: SessionActionEnum, isLeftHand: Bool?) {
        var data = [
            "entityType": "session",
            "id": currentSessionId.uuidString,
            "action": action.stringValue,
            "timestamp": Date()] as [String : Any]
        if let isLeftHand = isLeftHand {
            data["isLeftHand"] = isLeftHand
        }
        
        watchPhoneConnector.sendDataToiPhone(data: data)
    }
}
