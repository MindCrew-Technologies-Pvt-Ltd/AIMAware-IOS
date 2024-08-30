//
//  MlActiveAlert.swift
//  AImAware WatchKit App
//
//  Created by Sune on 02/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

class MlActiveAlert : ActiveAlert {
    
    private var alertDelayCountUp = 0
    private var armDirectionAtAlert : SIMD3<Double>
    private var armNotLoweredSinceLastAlarm = false
    var timer = Timer()
    var newTimer = Timer()
    var playSoundTimer : Timer?
    var countdownSeconds = 0.0

    init(probabilityDictionary: [String : Double], currentArmDirection: SIMD3<Double>) {
        self.armDirectionAtAlert = currentArmDirection
        
        super.init(probabilityDictionary: probabilityDictionary, isPrimary: true)
    }
    
    
    override func updateIsHandStillNearPostion(normalisedMotionData: NormalisedMotionData) {
        
        let currentArmDirection = SIMD3<Double>(x: normalisedMotionData.m11, y: normalisedMotionData.m12, z: normalisedMotionData.m13)
        print("dot(currentArmDirection, armDirectionAtAlert) \(dot(currentArmDirection, armDirectionAtAlert)) normalisedMotionData.gX \(normalisedMotionData.gX)")
        
        /*if UserDefaults.standard.bool(forKey: "isRinging") && UserDefaults.standard.bool(forKey: "isStopVibration") && dot(currentArmDirection, self.armDirectionAtAlert) < 0.80{
            UserDefaults.standard.set(false, forKey: "isRinging")
            UserDefaults.standard.set(false, forKey: "fromUper")
        }
                
        if dot(currentArmDirection, armDirectionAtAlert) > 0.90 && (normalisedMotionData.gX >= 0.60 && normalisedMotionData.gX <= 0.90) && UserDefaults.standard.bool(forKey: "isStopVibration") && !UserDefaults.standard.bool(forKey: "isRinging"){
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(settings.alertDelay)){
                WKInterfaceDevice.current().play(.failure)
            }
            
            UserDefaults.standard.set(true, forKey: "fromUper")
        
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(settings.alertDelay + 5.0)){
                UserDefaults.standard.set(true, forKey: "isRinging")
            }
            
        }else if dot(currentArmDirection, armDirectionAtAlert) < 0.85 && UserDefaults.standard.bool(forKey: "isStopVibration") && !UserDefaults.standard.bool(forKey: "isRinging") && UserDefaults.standard.bool(forKey: "fromUper"){
            
           // print("before bottom ringingggggggggggggggggg")
            WKInterfaceDevice.current().play(.failure)
        }*/
        
        if dot(currentArmDirection, armDirectionAtAlert) > 0.90 && (normalisedMotionData.gX >= 0.60 && normalisedMotionData.gX <= 0.85) && UserDefaults.standard.bool(forKey: "isStopVibration") {
            print("before timer started")
            if !UserDefaults.standard.bool(forKey: "isTimerStarted"){
                UserDefaults.standard.set(true, forKey: "isTimerStarted")
                print("timer started")
                
                if settings.alertDelay <= 1{
                    WKInterfaceDevice.current().play(.failure)
                }
                UserDefaults.standard.set(true, forKey: "fromUper")
                let userInfo = ["normalizedData": normalisedMotionData]
                self.newTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.newTimerAction(_:)), userInfo: userInfo, repeats: true)
            }
        }else if UserDefaults.standard.bool(forKey: "isStopVibration") && UserDefaults.standard.bool(forKey: "fromUper") {
            
            print("counterValue \(countdownSeconds)")
            if countdownSeconds == settings.alertDelay{
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                    print("Xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
                    UserDefaults.standard.set(false, forKey: "fromUper")
                    UserDefaults.standard.set(false, forKey: "isTimerStarted")
                    self.newTimer.invalidate()
                    self.countdownSeconds = 0.0
                }
            }else{
                UserDefaults.standard.set(false, forKey: "fromUper")
                UserDefaults.standard.set(false, forKey: "isTimerStarted")
                self.newTimer.invalidate()
                self.countdownSeconds = 0.0
            }
        }
        
        
        if dot(currentArmDirection, armDirectionAtAlert) > 0.85 || normalisedMotionData.gX >= 0.1 {
            
            if !UserDefaults.standard.bool(forKey: "isHandStillNearPostion") && !UserDefaults.standard.bool(forKey: "isStopVibration"){
                print("NNNNNNNNNNNNNNNNNNgottttttttttttttttt itttttttttt \(settings.alertDelay)")
                if dot(currentArmDirection, armDirectionAtAlert) > 0.90 && (normalisedMotionData.gX >= 0.60 && normalisedMotionData.gX <= 0.90)
                {
                    print("Before timer started")
                    if !UserDefaults.standard.bool(forKey: "isTimerStarted"){
                        UserDefaults.standard.set(true, forKey: "isTimerStarted")
                        print("timer started")
                        let userInfo = ["normalizedData": normalisedMotionData]
                        self.newTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.newTimerAction(_:)), userInfo: userInfo, repeats: true)
                    }
                    
                }else{
                    UserDefaults.standard.set(false, forKey: "isTimerStarted")
                    self.timer.invalidate()
                    self.newTimer.invalidate()
                    countdownSeconds = 0.0
                }
                
            }
        }else{
            if !self.settings.isShowingBipAndViewAfterDelay {
                timer.invalidate()
                self.isHandStillNearPostion = dot(currentArmDirection, armDirectionAtAlert) > 0.85 || normalisedMotionData.gX >= 0.1
            }
        }
    }
    
    // called every time interval from the timer
    @objc func timerAction() {
        //print("before timerAction????")
        if !settings.isShowingBipAndViewAfterDelay{
            //print("after timerAction????")
            UserDefaults.standard.set(false, forKey: "isStopVibration")
            timer.invalidate()
        }else{
            //print("tttttt timerAction????")
            if !UserDefaults.standard.bool(forKey: "isComeFirst"){
                UserDefaults.standard.set(true, forKey: "isComeFirst")
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(5.0)){
                    print("stoppeddddddd")
                    UserDefaults.standard.set(true, forKey: "isStopVibration")
                    UserDefaults.standard.set(false, forKey: "isTimerStarted")
                    self.timer.invalidate()
                    self.newTimer.invalidate()
                    
                }
            }
                        
            if !UserDefaults.standard.bool(forKey: "isStopVibration"){
                //print("rrrrrrr timerAction????")
                WKInterfaceDevice.current().play(.failure)
            }
        }
    }
    
    @objc func newTimerAction(_ timer: Timer) {
        
        if let userInfo = timer.userInfo as? [String: NormalisedMotionData],
           let normalisedMotionNewData = userInfo["normalizedData"] {
            if countdownSeconds == settings.alertDelay{
                print("countdown for ////// 0")
                checkHandStillNearPosition(normalisedMotionData: normalisedMotionNewData)
                
            }else{
                countdownSeconds += 1.0
                print("countdown for \(countdownSeconds)")
                checkHandStillNearPosition(normalisedMotionData: normalisedMotionNewData)
            }
        }
    }
    
    func checkHandStillNearPosition(normalisedMotionData: NormalisedMotionData){
        let currentArmDirection = SIMD3<Double>(x: normalisedMotionData.m11, y: normalisedMotionData.m12, z: normalisedMotionData.m13)
        print("checkHandStillNearPosition(norma")
        if dot(currentArmDirection, armDirectionAtAlert) > 0.90 && (normalisedMotionData.gX >= 0.60 && normalisedMotionData.gX <= 0.90){
            print("before countdown for \(countdownSeconds)")
            if countdownSeconds == settings.alertDelay{
                print("after countdown for \(countdownSeconds)")
                if UserDefaults.standard.bool(forKey: "isStopVibration"){
                    print("playsounddddddddddddddddd")
                    if dot(currentArmDirection, armDirectionAtAlert) > 0.90 && (normalisedMotionData.gX >= 0.60 && normalisedMotionData.gX <= 0.90){
                        WKInterfaceDevice.current().play(.failure)
                    }
                    
                }else{
                    print("notttttttttt playsounddddddddddddddddd")
                    callTrigger(normalisedMotionData: normalisedMotionData)
                }
            }
        }else{
            print("timer invalidateddddddddddddddd")
            countdownSeconds = 0.0
            self.newTimer.invalidate()
            UserDefaults.standard.set(false, forKey: "isTimerStarted")
        }
    }
    
    func callTrigger(normalisedMotionData: NormalisedMotionData){
        UserDefaults.standard.set(true, forKey: "isHandStillNearPostion")
        let currentArmDirection = SIMD3<Double>(x: normalisedMotionData.m11, y: normalisedMotionData.m12, z: normalisedMotionData.m13)
        countdownSeconds = 0.0
        self.newTimer.invalidate()
        self.isHandStillNearPostion = dot(currentArmDirection, self.armDirectionAtAlert) > 0.85 || normalisedMotionData.gX >= 0.1
        self.settings.isShowingBipAndViewAfterDelay = true
        
        self.timer.invalidate()
        // start the timer
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }
    
    /*func playSoundAndVibration(){
        
        //self.playSoundTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.playSoundTimerAction), userInfo: nil, repeats: true)
        self.playSoundTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            // Perform actions
            self?.playSoundTimerAction()
        }
//        if !UserDefaults.standard.bool(forKey: "isRinging"){
//            WKInterfaceDevice.current().play(.failure)
//        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + Double(5.0)){
//            print("newtimerstopedddddddddddddddddddd")
//            self.countdownSeconds = 0.0
//            self.playSoundTimer?.invalidate()
//            self.playSoundTimer = nil
//            self.newTimer.invalidate()
//            UserDefaults.standard.set(true, forKey: "isRinging")
//            UserDefaults.standard.set(false, forKey: "isTimerStarted")
//        }
    }
    
    @objc func playSoundTimerAction() {
        print("playinggggggggggggggggggggggggggg")
        //if !UserDefaults.standard.bool(forKey: "isNotRinging"){
            WKInterfaceDevice.current().play(.failure)
        //}
    }*/
}
