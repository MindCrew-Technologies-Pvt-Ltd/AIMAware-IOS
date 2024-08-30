//
//  ActiveAlert.swift
//  AImAware WatchKit App
//
//  Created by Sune on 02/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI


class ActiveAlert {
    @ObservedObject var settings = WatchSettings.shared
    
    @Published var userAnswers : [String] = []
    @Published private(set) var specificAreaString : String
    @Published private(set) var isPrimary : Bool
    @Published private(set) var specificAreaDictionary : [(String, Double)]
    
    private var specificAreaGivenByUser: SpecificArea?
    var activeAlertStarted : Date
    var userAlerted = false
    var isHandStillNearPostion = true
    
    weak var delegate: ActiveAlertServiceDelegate?
    
    let appSessionService = AppSessionService.shared
    let watchPhoneConnector = WatchPhoneConnector.shared
    let alertQuestionService = AlertQuestionService.shared
    
    
    var nextQuestion: AlertQuestion? {
        return alertQuestionService.calculateNextQuestion(previousAnswers: self.userAnswers, nonDeveloperMode: !settings.developerSettings, specificAreaString: self.specificAreaString, isPrimary: self.isPrimary)
    }
    
    var status: AlertStatusEnum? {
        if (self.userAnswers.count > 0 ) {
            if (self.userAnswers[0] == (String(SharedConstants.correctQuestionId) + ":👍")) {
                return AlertStatusEnum.confirmed
            } else {
                return AlertStatusEnum.denied
            }
        } else {
            return AlertStatusEnum.ignored
        }
        
    }
    
    init(probabilityDictionary: [String : Double], isPrimary: Bool) {
        self.activeAlertStarted = Date()
        self.isPrimary = isPrimary
        
        let orderedScalarDictionary = Self.getOrderedDictionaryFromProbDict(probDict: probabilityDictionary)
        
        self.specificAreaDictionary = orderedScalarDictionary
        self.specificAreaString = Self.getStringFromScalarDict(orderedScalarDictionary: orderedScalarDictionary)
        
        self.considerAlertUser(ignoreDelay : false)
    }
    
    static func getOrderedDictionaryFromProbDict(probDict: [String: Double]) -> [(String, Double)] {
        let maxValue = probDict.values.max() ?? 1
        
        var scalarDict: [String: Double] = [:]
        // Divide all numbers by the maximum value, then multiply by 10 and round to 2 decimals
        for (key, value) in probDict {
            let normalizedValue = value / maxValue
            scalarDict[key] = Double(round(100 * normalizedValue * 10) / 100)
        }
        
        // Sort the dictionary by value in descending order
        let sortedDict = scalarDict.sorted { $0.value > $1.value }
        
        return sortedDict
    }
    
    static fileprivate func getStringFromScalarDict(orderedScalarDictionary: [(String, Double)]) -> String {
        // Convert sorted dictionary to multiline string
        var resultString = ""
        for (key, value) in orderedScalarDictionary {
            resultString += "\(key.capitalized): \(String(format: "%.2f", value))\n"
        }
        
        // Remove the trailing newline character
        resultString = String(resultString.dropLast())
        
        // Your final multiline string
        return resultString
    }
    
    func setDelegate(delegate: ActiveAlertServiceDelegate) {
        self.delegate = delegate
    }
    
    func update(normalisedMotionData: NormalisedMotionData) {
        //print("before update(normalised")
        /*if (activeAlertStarted.addingTimeInterval(settings.activeAlertDurationSeconds) < Date()) {
            print("after update(normalised")
            interrupt()// handle user answers (for when it is ignored or when there is more than one question)
        }*/
        //print("update(nor")
        if self.isHandStillNearPostion {
            updateIsHandStillNearPostion(normalisedMotionData: normalisedMotionData)
            if self.isHandStillNearPostion {
                handleHandStillNearPostion()
            } else {
                handleHandMovedAwayFromPostion()
            }
        }
    }
    
    func updateIsHandStillNearPostion(normalisedMotionData: NormalisedMotionData) {
        // do nothing
    }
    
    func handleHandStillNearPostion() {
        self.considerAlertUser(ignoreDelay: false)
    }
    
    func handleHandMovedAwayFromPostion() {
        self.considerAlertUser(ignoreDelay: true)
    }
    
    func considerAlertUser(ignoreDelay: Bool) {
        if (ignoreDelay || activeAlertStarted.addingTimeInterval(settings.observationDelay) < Date()) {
            if (settings.persistentAlert || !self.userAlerted) {
                if (self.isPrimary) {
                    
                    if settings.isShowingBipAndViewAfterDelay {
                        if !UserDefaults.standard.bool(forKey: "isComeFirst"){
                            UserDefaults.standard.set(true, forKey: "isComeFirst")
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double(5.0)){
                                print("stoppeddddddd111111111")
                                UserDefaults.standard.set(true, forKey: "isStopVibration")
                                UserDefaults.standard.set(false, forKey: "isTimerStarted")
                            }
                        }
                        //print("before NearPostion >>>>>>>>>>>>>????")
                        if !UserDefaults.standard.bool(forKey: "isStopVibration"){
                            //print("after NearPostion >>>>>>>>>>>>>????")
                            WKInterfaceDevice.current().play(.failure)
                        }
                        
                    }else{
                        UserDefaults.standard.set(false, forKey: "isStopVibration")
                    }
                    
                } else {
                    //print("isStopVibration11 not working")
                    WKInterfaceDevice.current().play(.success)
                    //WKInterfaceDevice.current().play(.notification)// good, but we might not want to be confused with notifications
                    //WKInterfaceDevice.current().play(.retry) // indistinguishable from failure
                    //WKInterfaceDevice.current().play(.success) // not quite strong enough
                    
                    //WKInterfaceDevice.current().play(.start) // way too discrete, unless repeated
                    //WKInterfaceDevice.current().play(.stop) // way too discrete, unless repeated
                    //WKInterfaceDevice.current().play(.directionUp)// way too discrete, unless repeated
                    //WKInterfaceDevice.current().play(.directionDown)// way too discrete, unless repeated
                    
                    //WKInterfaceDevice.current().play(.navigationGenericManeuver)// ingen reaktion
                    
                    //if #available(watchOS 9.0, *) {
                    //WKInterfaceDevice.current().play(.underwaterDepthPrompt)// none
                    //}
                }
                //print("isStopVibration1111 not working")
                self.userAlerted = true
                
            }
        }
    }
    
    func allowNewAlert() -> Bool {
        //print("allowNewAlert isHandStillNearPostion \(self.isHandStillNearPostion)")
        return !self.isHandStillNearPostion
    }
    
    func interrupt() {
        print("call question from intrupt")
        self.questionsAnswered()
    }
    
    func appendAnswer(questionId: Int, answer : String) {
        //print("appendAnswer <<<<<<<<")
        self.userAnswers.append(String(questionId) + ":" + answer)
        if (self.nextQuestion == nil) {
            //print("call question from append answer")
            questionsAnswered()
        }
    }
    
    fileprivate func questionsAnswered() {
        //print("questionsAnswered >>>>>")
        alertStatusDetermined(status: self.status ?? .ignored)
    }
    
    /*func appendSpecificArea(specificArea : SpecificArea) {
     self.specificAreaGivenByUser = specificArea
     let answer: AlertOption
     if specificArea.code == 0 {
     answer = AlertOption.optionFalse
     } else {
     answer = AlertOption.optionTrue
     }
     appendAnswer(answer : answer.optionText())
     }*/
    
    func alertStatusDetermined(status: AlertStatusEnum) {
        print("alertStatusDetermined >>> \(status) <<< \(isPrimary)")
        if (status != .denied && (self.isPrimary || status == .confirmed)) {
            self.delegate?.addConfirmedAlert()
        }
        notifyiPhone(status: status)
        self.delegate?.resetAlert()
    }
    
    fileprivate func notifyiPhone(status: AlertStatusEnum) {
        watchPhoneConnector.sendDataToiPhone(data: [
            "entityType": "alert",
            SharedConstants.isSecondaryAlert: !self.isPrimary,
            "status": status.stringValue,
            "timestamp": activeAlertStarted,
            "sessionId": appSessionService.currentSessionId.uuidString,
            SharedConstants.specificAreaGivenByUser: self.specificAreaGivenByUser?.code ?? -1,
            SharedConstants.userAnswers: userAnswers.map{$0},
            SharedConstants.handStillNearPosition : self.isHandStillNearPostion,
            SharedConstants.userAlerted : self.userAlerted
        ])
    }
}



