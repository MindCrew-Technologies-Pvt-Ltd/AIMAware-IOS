//
//  RecordSessionService.swift
//  DontBiteYourNails WatchKit Extension
//
//  Created by Sune Kristian Jakobsen on 28/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

class RecordSessionService {
    static let shared = RecordSessionService()
    
    let appSessionService = AppSessionService.shared
    let watchPhoneConnector = WatchPhoneConnector.shared
    
    private var motionData : [NormalisedMotionData] = []
    
    func recordMovement(currentNormalisedMotionData: NormalisedMotionData?) {
        if let currentNormalisedMotionData = currentNormalisedMotionData {
            motionData.append(currentNormalisedMotionData)
            
            if (motionData.count >= 75) {
                flush()
            }
        }
    }
    
    func flush() {
        if motionData.count > 0 {
            notifyiPhone()
        }
    }
    
    fileprivate func resetMovementData() {
        motionData = []
    }
    
    fileprivate func notifyiPhone() {
        var normalisedMotionDataString = ""
        for datapoint in motionData {
            normalisedMotionDataString += datapoint.toString() + "|"
        }

        watchPhoneConnector.sendDataToiPhone(data: [
            "entityType": "sessionRecording",
            "timestamp": Date(),
            "sessionId": appSessionService.currentSessionId.uuidString,
            "motiondata": normalisedMotionDataString,
        ])
        print("Notified iphone")
        self.resetMovementData()
    }
}


