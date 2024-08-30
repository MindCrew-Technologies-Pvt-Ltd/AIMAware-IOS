//
//  SharedConstants.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 28/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

let USER_DEFAULTS = UserDefaults.standard
let USERID = "userId"
let SHAREUSAGE = "shareUsage"
let FROMSIGNUP = "fromSignup"
let COMPLETESIGNUPDATA = "completeSignUpData"
let GETTINGNOTIFICATIONDATA = "gettingNotificationData"
let FROMWELCOMEPAGE = "fromWelcomePage"
let LOGINTYPE = "loginType"

var SHAREUSAGEDATA: Bool{
    return USER_DEFAULTS.bool(forKey: SHAREUSAGE)
}

struct SharedConstants {
    
    // settings 
    static let selectedSessionType = "selectedSessionType"
    static let developerSettings = "developerSettings"
    static let recordFullSessionKey = "recordFullSessionKey"
    static let alertDelayKey = "alertDelayKey"
    static let settingsVersionKey = "settingsVersionKey"
    static let autoRecord = "autoRecord" // data not send to watch
    static let persistentAlert = "persistentAlert"
    static let areaSensitivities = "areaSensitivities"
    static let useSpecificAlerts = "useSpecificAlerts"
    static let observationDelay = "observationDelay"
    static let alertsOn = "alertsOn"
    static let includeSecondaryAlert = "includeSecondaryAlert"
    static let reminderNotificationKey = "reminderNotificationKey"
    static let deleteNotificationKey = "deleteNotificationKey"
    static let weekendNotificationKey = "weekendNotificationKey"
    
    // privacy settings
    
    static let privacyMetadata = "privacyMetadata"
    static let privacyMovementData = "privacyMovementData"
    static let privacyUseEmail = "privacyUseEmail"
    
    // wants to work on choices
    static let wantsToWorkOnHairPulling = "wantsToWorkOnHairPulling"
    static let wantsToWorkOnSkinPicking = "wantsToWorkOnSkinPicking"
    static let wantsToWorkOnNailBiting = "wantsToWorkOnNailBiting"
    static let wantsToWorkOnNosePicking = "wantsToWorkOnNosePicking"
    static let wantsToWorkOnOther = "wantsToWorkOnOther"
    static let wantsToWorkOnOtherStringAnswer = "wantsToWorkOnOtherStringAnswer"
    
    
    static let hasCompleteIntro = "hasCompleteIntro"
    static let currentIntroStep = "currentIntroStep"
    
    
    // user confi
    static let userHeight = "userHeight"
    
    
    // devices:
    
    static let watch = "W"
    static let phone = "P"
    static let deviceId = "deviceId"
    
    
    //watch phone communication
    /// entity types (message types)
    static let sessionRecording = "sessionRecording"
    static let session = "session"
    static let alert = "alert"
    static let mlCall = "mlCall"
    
    
    
    /// information types
    static let entityType = "entityType"
    static let timestamp = "timestamp"
    static let sessionId = "sessionId"
    static let motiondata = "motiondata"
    static let inputDataReady = "inputDataReady"
    static let modelFetched = "modelFetched"
    static let modelOutputReady = "modelOutputReady"
    static let timeArray = "timeArray"
    static let specificAreaGivenByUser = "specificAreaGivenByUser"
    static let isSecondaryAlert = "isSecondaryAlert"
    static let userAlerted = "userAlerted"
    static let handStillNearPosition = "handStillNearPosition"
    static let userAnswers = "userAnswers"
    
    /// event types
    static let tap = "tap"
    static let artificialPositive = "artificialPositive"
    static let dataEpisode = "dataEpisode"
    static let minorMovementEvent = "minorMovementEvent"
    static let reportedError = "reportedError"
    
    
    //mlCall data
    static let outputProbability = "outputProbability"
    static let input = "input"
    static let output = "output"
    static let features = "features"
    static let beforeTime = "beforeTime"
    static let featuresCalculatedTime = "featuresCalculatedTime"
    static let timeDone = "timeDone"
    
    static let model = "model"
    static let rnn = "rnn"
    static let specificArea = "specificArea"
    

    // question numbers
    static let correctQuestionId = 0
    static let feelingQuestionId = 100
    static let urgeQuestionId = 200
    static let situationQuestionId = 300
    
    
    // emojis
    static let thumpsDown = "👎"
    static let thumpsUp = "👍"
    
    // correctnessAnswer
    static let confirmed = "confirmed"
    static let ignored = "ignored"
    static let denied = "denied"
    
}
