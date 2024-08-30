//
//  NormalisedMotionData.swift
//  DontBiteYourNails WatchKit Extension
//
//  Created by Sune Kristian Jakobsen on 15/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import CoreMotion

//import SwiftUI // only used for testing
//WKInterfaceDevice.current().play(.success)

class NormalisedMotionData : Codable {
    // watch orientation
    let watchPlacement : WatchPlacement
    
    let motionDataTimestamp : TimeInterval
    let deviceTimestamp : Double

    /*
    let attitudePitch : Double // rotation around x axis. Postive when rotating to look at watch
    let attitudeRoll : Double // rotation around y axis. Positive when raising hand above elbow
    let attitudeYaw : Double // rotation around z axis. Positive direction when moving hand towards you
    */
    let gX : Double
    let gY : Double
    let gZ : Double
    
    let attitudeQuatX : Double // x,y,z together gives the vector that the rotation is around,
    let attitudeQuatY : Double // and the length of the vector is sin(angle of rotation/2)
    let attitudeQuatZ : Double
    let attitudeQuatW : Double // cos of half the angle of rotation
    
    let accelX : Double// accel towards opposite side
    let accelY : Double// accel towards inside. Towards you
    let accelZ : Double// accel down. I dont know why, it should have been upwards.
    
    let heading : Double
    let headingAtRaise : Double
    
    let rotationX : Double
    let rotationY : Double
    let rotationZ : Double
    
    let m11 : Double
    let m12 : Double
    let m13 : Double
    let m21 : Double
    let m22 : Double
    let m23 : Double
    let m31 : Double
    let m32 : Double
    let m33 : Double
    
    static var offSetFromFirstDataPoint : Date?
    
    convenience init(motionData : CMDeviceMotion) {
        if Self.offSetFromFirstDataPoint == nil {
            Self.offSetFromFirstDataPoint = Date().addingTimeInterval(-motionData.timestamp)
        }
        
        self.init(motionData: motionData, headingAtRaise: 0, watchPlacement: WatchPlacement(crownLocation: 1.0, wristLocation: 1.0))//, deviceTimestampReference: Self.offSetFromFirstDataPoint)
    }
    
    init(motionData : CMDeviceMotion, headingAtRaise: Double, watchPlacement : WatchPlacement//, deviceTimestampReference: Date?
    ) {
        self.watchPlacement = watchPlacement
        
        
        self.motionDataTimestamp = motionData.timestamp //+ (deviceTimestampReference?.timeIntervalSinceReferenceDate ?? 0)
        self.deviceTimestamp = Date().timeIntervalSinceReferenceDate
        
        self.gX = motionData.gravity.x * watchPlacement.getXMultiplier()
        self.gY = motionData.gravity.y * watchPlacement.getYMultiplier()
        self.gZ = motionData.gravity.z * watchPlacement.getZMultiplier()

        self.attitudeQuatX = motionData.attitude.quaternion.x * watchPlacement.getXMultiplier()// verified
        self.attitudeQuatY = motionData.attitude.quaternion.y * watchPlacement.getYMultiplier()// verified
        self.attitudeQuatZ = motionData.attitude.quaternion.z * watchPlacement.getZMultiplier()// verified
        self.attitudeQuatW = motionData.attitude.quaternion.w * watchPlacement.getWQuatMultiplier()// verified
        
        self.accelX = motionData.userAcceleration.x * watchPlacement.getXMultiplier()
        self.accelY = motionData.userAcceleration.y * watchPlacement.getYMultiplier()
        self.accelZ = motionData.userAcceleration.z * watchPlacement.getZMultiplier()
        
        self.heading = motionData.heading * watchPlacement.getHeadingMultiplier()
        self.headingAtRaise = headingAtRaise * watchPlacement.getHeadingMultiplier()
        
        self.rotationX = motionData.rotationRate.x * watchPlacement.getXRotationMultiplier()
        self.rotationY = motionData.rotationRate.y * watchPlacement.getYRotationMultiplier()
        self.rotationZ = motionData.rotationRate.z * watchPlacement.getZRotationMultiplier()
        
        
        self.m11 = motionData.attitude.rotationMatrix.m11
        self.m12 = motionData.attitude.rotationMatrix.m12 * watchPlacement.getXMultiplier()  * watchPlacement.getYMultiplier()
        self.m13 = motionData.attitude.rotationMatrix.m13 * watchPlacement.getXMultiplier()  * watchPlacement.getZMultiplier()
        self.m21 = motionData.attitude.rotationMatrix.m21 * watchPlacement.getYMultiplier()  * watchPlacement.getXMultiplier()
        self.m22 = motionData.attitude.rotationMatrix.m22
        self.m23 = motionData.attitude.rotationMatrix.m23 * watchPlacement.getYMultiplier()  * watchPlacement.getZMultiplier()
        self.m31 = motionData.attitude.rotationMatrix.m31 * watchPlacement.getZMultiplier()  * watchPlacement.getXMultiplier()
        self.m32 = motionData.attitude.rotationMatrix.m32 * watchPlacement.getZMultiplier()  * watchPlacement.getYMultiplier()
        self.m33 = motionData.attitude.rotationMatrix.m33
    }
    
    init(from: String) {
        let strings = from.split(separator: ";").map { String($0) }
        
        self.motionDataTimestamp = Double(strings[0]) ?? -1
        self.deviceTimestamp = Double(strings[18]) ?? -1
        self.gX = Double(strings[1]) ?? -1
        self.gY = Double(strings[2]) ?? -1
        self.gZ = Double(strings[3]) ?? -1
        self.attitudeQuatX = Double(strings[4]) ?? -1
        self.attitudeQuatY = Double(strings[5]) ?? -1
        self.attitudeQuatZ = Double(strings[6]) ?? -1
        self.attitudeQuatW = Double(strings[7]) ?? -1
        self.accelX = Double(strings[8]) ?? -1
        self.accelY = Double(strings[9]) ?? -1
        self.accelZ = Double(strings[10]) ?? -1
        self.heading = Double(strings[11]) ?? -1
        self.headingAtRaise = Double(strings[12]) ?? -1
        self.rotationX = Double(strings[13]) ?? -1
        self.rotationY = Double(strings[14]) ?? -1
        self.rotationZ = Double(strings[15]) ?? -1
        
        let crownLocation = Double(strings[16]) ?? 0
        let wristLocation = Double(strings[17]) ?? 0
        self.watchPlacement = WatchPlacement(crownLocation: crownLocation, wristLocation: wristLocation)
        
        self.m11 = Double(strings[19]) ?? 0
        self.m12 = Double(strings[20]) ?? 0
        self.m13 = Double(strings[21]) ?? 0
        self.m21 = Double(strings[22]) ?? 0
        self.m22 = Double(strings[23]) ?? 0
        self.m23 = Double(strings[24]) ?? 0
        self.m31 = Double(strings[25]) ?? 0
        self.m32 = Double(strings[26]) ?? 0
        self.m33 = Double(strings[27]) ?? 0
    }
    
    func totalAccel() -> Double {
        return pow(pow(self.accelX, 2) + pow(self.accelY, 2) + pow(self.accelZ, 2), 0.5)
    }
    
    
    func toString() -> String {
        
        let start = String(self.motionDataTimestamp) + ";" +
        String(self.gX)  + ";" +
        String(self.gY) + ";" +
        String(self.gZ) + ";"
        
        let quats =
        String(self.attitudeQuatX) + ";" +
        String(self.attitudeQuatY)  + ";" +
        String(self.attitudeQuatZ) + ";" +
        String(self.attitudeQuatW) + ";"
        
        let accel =
        String(self.accelX)  + ";" +
        String(self.accelY)  + ";" +
        String(self.accelZ)  + ";"
        
        let rotation =
        String(self.heading) + ";" +
        String(self.headingAtRaise) + ";" +
        String(self.rotationX) + ";" +
        String(self.rotationY)  + ";" +
        String(self.rotationZ)  + ";"
        
        let watchPlacementString = String(self.watchPlacement.crownLocation) + ";" +
        String(self.watchPlacement.wristLocation) + ";"
        
        let addedLater =
        String(self.deviceTimestamp) + ";"
        
        let matrix = String(self.m11) + ";" +
        String(self.m12) + ";" +
        String(self.m13) + ";" +
        String(self.m21) + ";" +
        String(self.m22) + ";" +
        String(self.m23) + ";" +
        String(self.m31) + ";" +
        String(self.m32) + ";" +
        String(self.m33)
        
        return start + quats + accel + rotation + watchPlacementString + addedLater + matrix
    }
    
}
