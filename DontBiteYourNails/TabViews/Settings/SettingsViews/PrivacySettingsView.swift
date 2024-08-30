//
//  PrivacySettings.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//


import Foundation
import SwiftUI

struct PrivacySettingsView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Heading("Privacy settings")
            PrivacyDataSettingsView()
            /*Spacer()
            PrivacyEmailSettingsView()*/
        }
    }
}


struct PrivacyDataSettingsView: View {
    @ObservedObject var privacySettings = PrivacySettings.shared
    
    var body: some View {
            VStack{
                Text("Currently all data is stored on the phone. In later versions, you will be able to help us improve the algortihm by sharing your data. No data will be shared until you give permission.")
               /* SettingsRowToggleView(
                    title: "Allow use of general data",
                    helpText: "Allows the AImAware team to use data about settings, sessions, and nudges to improve the product.",
                    toggleState: $privacySettings.privacyMetadata
                )
                SettingsRowToggleView(
                    title: "Allow use of movement data",
                    helpText: "Allows the AImAware team to use movement data from the seconds around nudges in order to improve the product. The app only stores movement data when you have an actiave session. If this is setting is off, no movement data will leave your devices.",
                    toggleState: $privacySettings.privacyMovementData
                )*/
            }
        }
}


struct PrivacyEmailSettingsView: View {
    @ObservedObject var privacySettings = PrivacySettings.shared
    
    var body: some View {
        VStack{
            SettingsRowToggleView(
                title: "Allow use of email",
                helpText: "Allows the AImAware tema to contact me when there are new features that might be relevant for me",
                toggleState: $privacySettings.privacyUseEmail
            )
        }
        
    }
}

