//
//  AlertQuestionService.swift
//  AImAware
//
//  Created by Sune on 17/12/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

class AlertQuestionService {
    private static let sharedInstance = AlertQuestionService()
    let config = Config.shared
    @ObservedObject private var settings = WatchSettings.shared
    private var specificAreaString : String?
    
    static var shared: AlertQuestionService {
        return sharedInstance
    }
    
    
    func calculateNextQuestion(previousAnswers: [String], nonDeveloperMode: Bool, specificAreaString: String, isPrimary: Bool) -> AlertQuestion? {
        self.specificAreaString = specificAreaString
        switch previousAnswers.count {
        case 0:
            if settings.isShowingBipAndViewAfterDelay {
                return isPrimary ? AlertQuestion.correctness : AlertQuestion.shouldHaveAlert
            }else{
                return nil
            }
            
        case 1:
            if (config.shouldAskFollowup && previousAnswers[0] != "0:👎") {
                return AlertQuestion.feeling
            } else {
                return nil
            }
        case 2:
            if (config.shouldAskFollowup && previousAnswers[0] != "0:👎") {
                return AlertQuestion.urgeIntensity
            } else {
                return nil
            }
        case 3:
            if (config.shouldAskFollowup && previousAnswers[0] != "0:👎") {
                return AlertQuestion.situation
            } else {
                return nil
            }
        default:
            UserDefaults.standard.set(false, forKey: "isHandStillNearPostion")
            UserDefaults.standard.set(false, forKey: "isTimerStarted")
            UserDefaults.standard.set(false, forKey: "isStopVibration")
            UserDefaults.standard.set(false, forKey: "isComeFirst")
            UserDefaults.standard.set(false, forKey: "isRinging")
            UserDefaults.standard.set(false, forKey: "fromUper")
            self.settings.isShowingBipAndViewAfterDelay = false
            return nil
            /*if (nonDeveloperMode || previousAnswers[0] == "0:👎") {
                return nil
            } else {
                return AlertQuestion.minorMovement
            }
        default:
            return nil*/
      /*  case 2:
            if (previousAnswers[0] == AlertOption.optionTrue) {
                return AlertQuestion.broadPositiveCategory
            } else {
                return AlertQuestion.falseCategories
            }
        default:
            switch previousAnswers[previousAnswers.count - 1] {
            case AlertOption.face:
                return AlertQuestion.faceArea
            case AlertOption.top:
                return AlertQuestion.topArea
            case AlertOption.leftSide, AlertOption.rightSide:
                return AlertQuestion.sideArea
            case AlertOption.eye, AlertOption.neck, AlertOption.shoulder:
                return AlertQuestion.whichSide
            case AlertOption.nose, AlertOption.forehead:
                return AlertQuestion.whichSideOrMiddle
            case AlertOption.otherMain:
                return AlertQuestion.otherArea
            default:
                return nil
            }*/
        }
    }
}



