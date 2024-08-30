//
//  AverageAccelGuard.swift
//  AImAware WatchKit App
//
//  Created by Sune on 02/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

class AverageAccelAlertCreatorGuard : AlertCreator {
    
    private var innerGuard : AlertCreator
    private var lastTotalAccels = CircularBuffer(size: 5)
    
    init(innerGuard : AlertCreator) {
        self.innerGuard = innerGuard
    }
    
    func addElement(normalisedMotionData: NormalisedMotionData) {
        //print("alert createor addElement(normalisedMoti")
        self.lastTotalAccels.addElement(normalisedMotionData.totalAccel())
        self.innerGuard.addElement(normalisedMotionData: normalisedMotionData)
    }
    
    func addElementAndMakeDecision(normalisedMotionData: NormalisedMotionData) -> ActiveAlert? {
        self.lastTotalAccels.addElement(normalisedMotionData.totalAccel())
        //print("addElementAndMakeDecision new >>>>")
        if (self.lastTotalAccels.getAverage() > 0.1) {
           // print("before lastTotalAccels.getAverage()")
            innerGuard.addElement(normalisedMotionData: normalisedMotionData)
            return nil
        } else {
            //print("after lastTotalAccels.getAverage()")
            return innerGuard.addElementAndMakeDecision(normalisedMotionData: normalisedMotionData)
        }
    }
}
