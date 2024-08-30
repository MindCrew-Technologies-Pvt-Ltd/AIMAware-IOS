//
//  WatchPlacement.swift
//  DontBiteYourNails WatchKit Extension
//
//  Created by Sune Kristian Jakobsen on 15/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

class WatchPlacement : Codable {
    let crownLocation : Double // 1 if crown is pointing right
    let wristLocation : Double // 1 if right hand
    
    init(crownLocation: Double, wristLocation: Double) {
        self.crownLocation = crownLocation
        self.wristLocation = wristLocation
    }
    
    
    public func getXMultiplier() -> Double {
        return crownLocation * wristLocation
    }
    
    public func getXRotationMultiplier() -> Double {
        return crownLocation
    }
    
    public func getYMultiplier() -> Double{
        return crownLocation
    }
    
    public func getYRotationMultiplier() -> Double {
        return crownLocation * wristLocation
    }
    
    public func getZMultiplier() -> Double{
        return 1.0
    }
    
    public func getZRotationMultiplier() -> Double {
        return wristLocation
    }
    
    public func getXTimesYMultiplier() -> Double {
        return wristLocation
    }
    
    public func getXTimesZMultiplier() -> Double {
        return crownLocation * wristLocation
    }
    
    public func getYTimesZMultiplier() -> Double {
        return crownLocation
    }
    
    public func getWQuatMultiplier() -> Double {
        return wristLocation
    }
    
    public func getHeadingMultiplier() -> Double {
        return wristLocation
    }
}
