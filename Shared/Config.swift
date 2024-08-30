//
//  Config.swift
//  AImAware
//
//  Created by Sune on 30/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation


class Config {
    static let shared = Config()
    
    let updateFrequency = 50.0
    let version = ""
    
    let episodeLength = 50
    
    
    let includeIntroFlow = false // false in prod
    let includeGraphView = false
    
    // false in prod
    let showDeveloperSettingsOptions = false
    let enableDataCollectionSessions = false
    let showDebugViewOnWatch = false
    let sendMLcallsToPhone = false
    let sharable = false
    

    let makeIntroflowSkipable = true
    let makeIntroflowRestartable = false // false in prod
    let makeWatchSetupSkipable = true // false in prod?
    
    // true in prod:
    let allowCachedAlertCount = true
    
    // work in progress
    let shouldAskFollowup = true
}
