//
//  NudgeSettingsView.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct GeneralNudgeSettingsView: View {
    let config = Config.shared
    
    var body: some View {
        if (config.showDeveloperSettingsOptions) {
            SessionTypeSelectionView()
        }
        Heading("Nudge settings")
        SingleNudgeSettingsView()
        
        Spacer()
        Text("To turn sound on/off for nudges and to change the strength of the nudges, you have to change the general settings of the watch. You can do this in the Watch app on iPhone or in the settings on the Watch. Here select 'Sounds&Haptic feedback'. ")

        
    }

}

struct SingleNudgeSettingsView: View {
    @ObservedObject var settings = PhoneSettings.shared
    
    var body: some View {
        /*SettingsRowView( // Nudge delay is not implemented for the current type of alert
            title: String(format: "Nudge delay", settings.alertDelay),
            helpText: String(format: "%.1f seconds", settings.alertDelay),
            //helpText: "Delay from your move your hand to near your head until you get a nudge. If you move your hand away before this you will not get a nudge and it will not apear in your statistics",
            control: Slider(value: $settings.alertDelay, in: 0...5, step: 0.5)
        )*/
        
        SettingsRowToggleView(
            title: "Insisting nudges",
            helpText: "Continue vibrating until you move the hand",
            toggleState: $settings.persistentAlert
        )
            
    }

}



struct SessionTypeSelectionView: View {
    @ObservedObject var settings = PhoneSettings.shared
    
    var body: some View {
        HStack{
            Text("Select Session Type")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 8)
                .padding(.leading, 16)
            //Spacer()
        }
        Picker("Select Session Type", selection: $settings.selectedSessionType) {
            ForEach(SessionType.allCases, id: \.self) {
                Text($0.rawValue)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .onChange(of: settings.selectedSessionType) { newValue in
            updateSessionType(for: newValue)
        }
        
    }
    
    func updateSessionType(for sessionType: SessionType) {
        print("Update user session")
        switch sessionType {
        case .normalUse:
            settings.developerSettings = false
        case .naturalRecorded:
            settings.developerSettings = true
            settings.recordFullSession = true
            settings.observationDelay = 5.0
            settings.alertsOn = true
            settings.includeSecondaryAlert = true
            settings.useSpecificAlerts = false
        case .developerSettings:
            settings.developerSettings = true
        case .majorMovement, .minorMovement:
            settings.developerSettings = true
            settings.recordFullSession = true
            print("alertsOn going to false")
            //settings.observationDelay = 0.0
            settings.alertsOn = false
            settings.includeSecondaryAlert = false
        }
    }
}
