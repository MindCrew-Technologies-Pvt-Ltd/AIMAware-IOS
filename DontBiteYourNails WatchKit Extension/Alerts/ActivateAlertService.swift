//
//  ActivateAlertService.swift
//  DontBiteYourNails WatchKit Extension
//
//  Created by Sune Kristian Jakobsen on 29/07/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI
import Foundation
import Combine
import simd
import WatchKit

protocol ActiveAlertServiceDelegate: AnyObject {
    func addConfirmedAlert()
    func resetAlert()
}

class ActivateAlertService : ObservableObject, ActiveAlertServiceDelegate {
    @ObservedObject var settings = WatchSettings.shared
    
    private var gestureTracker = GestureTracker()
    private var latestNormalisedMotionData: NormalisedMotionData?
    
    private var mainAlertCreator: AlertCreator = AverageAccelAlertCreatorGuard(innerGuard: MlModelAlertCreator())
    private var secondaryAlertCreator: AlertCreator = PrimitiveSensitiveAlertCreator()
    //private var innerGuard: MotionModelGuard = MlGuard()
    
    private var motionData : [NormalisedMotionData] = []
    
    @Published private(set) var numberOfConfirmedAlerts = 0
    @Published private(set) var activeAlert : ActiveAlert?
    @Published private(set) var secondaryAlert : ActiveAlert?
    
    
    func getNumberOfAlerts() -> Int {
        //print("getNumberOfAlerts \(numberOfConfirmedAlerts)")
        return numberOfConfirmedAlerts
    }
    
    func resetNumberOfAlerts() {
        numberOfConfirmedAlerts = 0
    }
    
    func mlAlert(normalisedMotionData: NormalisedMotionData?) {
        self.latestNormalisedMotionData = normalisedMotionData
        //print("mlAlert(nor")
        if let normalisedMotionData = normalisedMotionData {
            //print("ormalisedMotionData = nor")
            if let activeAlert = self.activeAlert {
                //print("activeAlert = self.a")
                activeAlert.update(normalisedMotionData: normalisedMotionData)
            }else{
                print("norrrrrrrrrr")
            }
            
            if (!allowNewAlert(isNewAlertPrimary: true)) {
                mainAlertCreator.addElement(normalisedMotionData: normalisedMotionData)
            } else {
                let newAlert = mainAlertCreator.addElementAndMakeDecision(normalisedMotionData: normalisedMotionData)
                
                if let newAlert = newAlert {
                    print("mlAlert >>>> first \(newAlert)")
                    startNewActiveAlert(newActiveAlert : newAlert)
                }
            }
            
            if (settings.includeSecondaryAlert){
                print("settings.includeSecondaryAlert")
                if (!allowNewAlert(isNewAlertPrimary: false)) {
                    secondaryAlertCreator.addElement(normalisedMotionData: normalisedMotionData)
                } else {
                    let newSecondaryAlert = secondaryAlertCreator.addElementAndMakeDecision(normalisedMotionData: normalisedMotionData)
                    if let newAlert = newSecondaryAlert {
                        startNewActiveAlert(newActiveAlert : newAlert)
                    }
                }
            }
        }else{
            print("activeAlert = self.a >>>>>>>>>>>>")
        }
    }
    
    fileprivate func allowNewAlert(isNewAlertPrimary : Bool) -> Bool {
        return self.activeAlert == nil || self.activeAlert!.allowNewAlert() || (isNewAlertPrimary && !self.activeAlert!.isPrimary)
    }
    
    
    fileprivate func startNewActiveAlert(newActiveAlert : ActiveAlert){
        //print("before startNewActiveAlert \(self.activeAlert)")
        if let activeAlert = self.activeAlert {
            //print("startNewActiveAlert>>>>>")
            activeAlert.interrupt()
        }
//        if settings.isShowingBipAndViewAfterDelay {
//            
//        }
        self.activeAlert = newActiveAlert
        self.activeAlert?.setDelegate(delegate: self)
    }
    
    
    func addConfirmedAlert() {
        print("addConfirmedAlert <<<<<<")
        self.numberOfConfirmedAlerts += 1
    }
    
    func resetAlert() {
        UserDefaults.standard.set(false, forKey: "isHandStillNearPostion")
        UserDefaults.standard.set(false, forKey: "isTimerStarted")
        UserDefaults.standard.set(false, forKey: "isStopVibration")
        UserDefaults.standard.set(false, forKey: "isComeFirst")
        UserDefaults.standard.set(false, forKey: "isRinging")
        UserDefaults.standard.set(false, forKey: "fromUper")
        print("resetAlert \(UserDefaults.standard.bool(forKey: "isStopVibration"))")
        self.settings.isShowingBipAndViewAfterDelay = false
        self.activeAlert = nil
    }
    
    /*
    func appendSpecificArea(specificArea : SpecificArea) {
        if let activeAlert = self.activeAlert {
            activeAlert.appendSpecificArea(specificArea : specificArea)
        }
    }*/
    
    func appendAnswer(questionId: Int, answer: String) {
        if let activeAlert = self.activeAlert {
            activeAlert.appendAnswer(questionId: questionId, answer : answer)
        }
    }
    
    var nextQuestion: AlertQuestion? {
        //print("next question activeAlert {{{{{")
        if let activeAlert = self.activeAlert {
            return activeAlert.nextQuestion
        } else {
            return nil
        }
    }
}
