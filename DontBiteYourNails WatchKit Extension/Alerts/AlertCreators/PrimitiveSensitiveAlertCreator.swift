//
//  PrimitiveSensitiveAlertCreator.swift
//  AImAware WatchKit App
//
//  Created by Sune on 02/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation


class PrimitiveSensitiveAlertCreator : AlertCreator {
    private var gestureTracker = GestureTracker()
    
    
    func addElement(normalisedMotionData: NormalisedMotionData) {
        print("AlertCreater addElement(normali")
        gestureTracker.addDataPoint(motionData: normalisedMotionData)
    }
    
    func addElementAndMakeDecision(normalisedMotionData: NormalisedMotionData) -> ActiveAlert? {
        print("ecision(normalisedMotion")
        if (normalisedMotionData.gX > 0.33) {
            let whichMovementTowardsHead = gestureTracker.whichMovementToHead()
            return PrimitiveActiveAlert(probabilityDictionary : whichMovementTowardsHead.1, isPrimary: false)
        } else {
            return nil
        }
    }
}
