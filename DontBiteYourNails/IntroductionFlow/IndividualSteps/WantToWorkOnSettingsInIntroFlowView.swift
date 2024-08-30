//
//  WantToWorkOnSettingsInIntroFlowView.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct WantToWorkOnSettingsInIntroFlowView: View {
    
    let advanceIntro: () -> Void
    
    var body: some View {
        SingleIntroductionSlideView(
            title: "Future requests",
            explanation: "We hope that in future versions of the app, you will be able to create more specific conditions for when you want a nudge, based on the habit you want to stop. Are there any habits you would like the app to be able to target? You choice will be send to us and will influence with features we are going to work on for later versions of the app.",
            content: {WantToWorkOnSettingsOptionsView()},
            advanceIntro: advanceIntro
        )
        
        /*
        Heading("Future requests")
        Description("We hope that in future versions of the app, you will be able to create more specific conditions for when you want a nudge, based on the habit you want to stop. Are there any habits you would like the app to be able to target? You choice will be send to us and will influence with features we are going to work on for later versions of the app.")
        WantToWorkOnSettingsOptionsView()
        Button(action: advanceIntro) {
            Text("Next")
        }*/

    }
}

