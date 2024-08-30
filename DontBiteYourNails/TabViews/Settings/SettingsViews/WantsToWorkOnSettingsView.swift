//
//  WantToWorkOnSettings.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct WantToWorkOnSettingsView: View {
    
    @ObservedObject var wantsToWorkOnSettings = WantsToWorkOnSettings.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            Heading("Behaviour to track")
            Footnote("Currently this is only used by the AImAware team to prioritise which features to work on.")
            WantToWorkOnSettingsOptionsView()
        }
    }
}


struct WantToWorkOnSettingsOptionsView: View {
    
    @ObservedObject var wantsToWorkOnSettings = WantsToWorkOnSettings.shared
    
    var body: some View {
            SettingsRowToggleView(
                title: "Hair pulling",
                toggleState: $wantsToWorkOnSettings.wantsToWorkOnHairPulling
            )
            SettingsRowToggleView(
                title: "Skin picking",
                toggleState: $wantsToWorkOnSettings.wantsToWorkOnSkinPicking
            )
            SettingsRowToggleView(
                title: "Nail biting",
                toggleState: $wantsToWorkOnSettings.wantsToWorkOnNailBiting
            )
            SettingsRowToggleView(
                title: "Nose picking",
                toggleState: $wantsToWorkOnSettings.wantsToWorkOnNosePicking
            )
            SettingsRowToggleView(
                title: "Other",
                toggleState: $wantsToWorkOnSettings.wantsToWorkOnOther
            )
            if (wantsToWorkOnSettings.wantsToWorkOnOther) {
                SettingsRowView(
                    title: "What habit would like like help to reduce?",
                    control: TextField("Enter your text", text: $wantsToWorkOnSettings.wantsToWorkOnOtherStringAnswer)
                )
            }
    }
}
