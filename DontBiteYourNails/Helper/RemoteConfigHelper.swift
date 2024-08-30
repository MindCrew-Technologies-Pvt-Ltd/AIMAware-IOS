//
//  RemoteConfigHelper.swift
//  AImAware
//
//  Created by Maulik Bhuptani on 28/02/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

@MainActor
class RemoteConfigHelper: ObservableObject {
    static let shared = RemoteConfigHelper()
    
    var updateFrequency = 50.0
    var version = ""
    
    var episodeLength = 50
    
    var includeIntroFlow = false // false in prod
    var includeGraphView = false
    
    // false in prod
    var showDeveloperSettingsOptions = false
    var enableDataCollectionSessions = false
    var showDebugViewOnWatch = false
    var sendMLcallsToPhone = false
    var sharable = false
    
    var makeIntroflowSkipable = true
    var makeIntroflowRestartable = false // false in prod
    var makeWatchSetupSkipable = true // false in prod?
    
    // true in prod:
    var allowCachedAlertCount = true
    
    // work in progress
    let shouldAskFollowup = true
    
    @Published var hasFinished = false
    
    func startFetching() async throws {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        do {
            let config = try await remoteConfig.fetchAndActivate()
            hasFinished = true
            switch config {
            case .successFetchedFromRemote:
                sendMLcallsToPhone = remoteConfig.configValue(forKey: "sendMLcallsToPhone").boolValue
                return
            case .successUsingPreFetchedData:
                sendMLcallsToPhone = remoteConfig.configValue(forKey: "sendMLcallsToPhone").boolValue
                return
            default:
                print("Error activating")
                return
            }
        } catch let error {
            print("Error fetching: \(error.localizedDescription)")
            hasFinished = true
        }
    }
}
