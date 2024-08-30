//
//  HandleSessionInfo.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 19/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import CoreData

class HandleSessionInfo {
    
    var sessionRepo = SessionRepo.shared
    var coreDataManager = CoreDataManager.shared
    
    
    func handleUserInfoSession(userInfo: [String : Any], persistentContainer : NSPersistentContainer) {
        print("UserInfo about session received")
        if let action = userInfo["action"] as? String {
            switch action {
            case SessionActionEnum.start.stringValue: createSessionFromUserInfo(userInfo: userInfo, persistentContainer: persistentContainer)
            case SessionActionEnum.renew.stringValue: updateSessionFromUserInfo(userInfo: userInfo, persistentContainer: persistentContainer)
            case SessionActionEnum.end.stringValue: updateSessionFromUserInfo(userInfo: userInfo, persistentContainer: persistentContainer)
            default: print("Failed to handle userInfo about session because action  \(action) is unknown")
            }
        } else {
            print("Action missing")
        }
    }
    
    func createSessionFromUserInfo(userInfo: [String : Any], persistentContainer : NSPersistentContainer) {
        print("Creating session from userInfo")
        
        if let id = userInfo["id"] as? String,
           let timestamp = userInfo["timestamp"] as? Date,
           let deviceId = userInfo[SharedConstants.deviceId] as? String,
           let isLeftHand = userInfo["isLeftHand"] as? Bool {
            
            sessionRepo.endUnendedSessions(persistentContainer: persistentContainer, deviceType: SharedConstants.watch, deviceId: deviceId)
            
            sessionRepo.createSession(persistentContainer, timestamp, id, isLeftHand, deviceType: SharedConstants.watch, deviceId: deviceId)
        } else {
            print("Failed to handle userInfo about session because info was missing")
        }
    }


    
    func updateSessionFromUserInfo(userInfo: [String : Any], persistentContainer : NSPersistentContainer) {
        print("Updating session from userInfo")
        if let id = userInfo["id"] as? String,
           let action = userInfo["action"] as? String,
           let timestamp = userInfo["timestamp"] as? Date {
            sessionRepo.updateSession(id: id, timestamp: timestamp, action: action)
            
        }
    }
    
    
}
