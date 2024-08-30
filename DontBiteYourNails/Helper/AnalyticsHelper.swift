//
//  AnalyticsHelper.swift
//  AImAware
//
//  Created by Maulik Bhuptani on 27/02/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics

class AnalyticsHelper {
    class func configureFirebase(){
        FirebaseApp.configure()
    }
    
    class func logEvent(key: String, value: String){
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id-\(key)",
            AnalyticsParameterItemName: value,
            AnalyticsParameterContentType: "cont",
        ])
    }
    
    class func logCreatedEvent(key: String, value: String) {
        Analytics.logEvent(key, parameters: [
            "user_id": value,
        ])
    }
    
    class func logUpdateDelayEvent(key: String, value: String, delay: Double) {
        Analytics.logEvent(key, parameters: [
            "user_id": value,
            "delay": delay
        ])
    }
}
