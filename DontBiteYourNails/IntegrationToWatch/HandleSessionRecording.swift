//
//  HandleSessionRecording.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 28/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import CoreData

class HandleSessionRecording {
    
    let sessionMotionDataRepo = SessionMotionDataRepo.shared

        
    func handleUserInfoSession(userInfo: [String : Any], persistentContainer : NSPersistentContainer) {
        print("Session recording received")
        if let sessionId = userInfo[SharedConstants.sessionId] as? String,
           let data = userInfo[SharedConstants.motiondata] as? String,
           let timestamp = userInfo[SharedConstants.timestamp] as? Date {
            print("Recorded data of size : \(data.count) bytes")
            
            sessionMotionDataRepo.addSessionMotionData(persistentContainer, timestamp, sessionId, data)
            
        } else {
            print("Failed to handle userInfo about session recording")
        }
    }
}

