//
//  MlModelAlertCreator.swift
//  AImAware WatchKit App
//
//  Created by Sune on 02/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

class MlModelAlertCreator : AlertCreator {
    @ObservedObject var settings = WatchSettings.shared
    
    private var gestureTracker = GestureTracker()
    
    func addElement(normalisedMotionData: NormalisedMotionData) {
        //print("MICreater addElement(normali")
        gestureTracker.addDataPoint(motionData: normalisedMotionData)
        
    }
    
    func addElementAndMakeDecision(normalisedMotionData: NormalisedMotionData) -> ActiveAlert? {
        var returnAlert : MlActiveAlert? = nil
        let currentArmDirection = SIMD3<Double>(x: normalisedMotionData.m11, y: normalisedMotionData.m12, z: normalisedMotionData.m13)
        //print("before gestureTracker.hasOngoingGesture")
        if (gestureTracker.hasOngoingGesture()) {
            // do ML to decide if alert should trigger
            gestureTracker.addDataPoint(motionData: normalisedMotionData)
            let whichMovementTowardsHead = gestureTracker.whichMovementToHead()
           //print("after gestureTracker.hasOngoingGesture")
            if (doesMovementTriggerAlert(movement: whichMovementTowardsHead)) {
                //print("doesMovementTriggerAlert usespecificalerts")
                returnAlert = createActiveAlert(probabilityDictionary : whichMovementTowardsHead.1, currentArmDirection: currentArmDirection)
            }
            
            gestureTracker.clear()// gesture stopped
        }
        return returnAlert
    }
    
    fileprivate func doesMovementTriggerAlert(movement: (Bool, [String: Double])) -> Bool {
        if !movement.0 {
            return false
        }
        //print("settings.useSpecificAlerts \(settings.useSpecificAlerts)")
        if !settings.useSpecificAlerts {
            //print("watch app setting usespecificalerts")
            return true
        }
        let specificAreaDictionary = ActiveAlert.getOrderedDictionaryFromProbDict(probDict: movement.1)
        
        for (target, likelyhoodRatio) in specificAreaDictionary {
            if let sensitivity = settings.areaSensitivities[target] {
                if sensitivity + likelyhoodRatio > 10.0 {
                   // print("likelyhoodRatio usespecificalerts")
                    return true
                }
            }
        }
        
        return false
    }
    
    fileprivate func createActiveAlert(probabilityDictionary: [String : Double], currentArmDirection: SIMD3<Double>) -> MlActiveAlert {

        return MlActiveAlert(probabilityDictionary: probabilityDictionary, currentArmDirection: currentArmDirection)
    }
}
