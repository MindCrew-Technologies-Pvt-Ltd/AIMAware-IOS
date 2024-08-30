//
//  NudgeSettingsInIntroFlowView.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct NudgeSettingsInIntroFlowView: View {
    
    let advanceIntro: () -> Void
    
    var body: some View {
        SingleIntroductionSlideView(
            title: "Nudge settings",
            explanation: "Select your preferred settings. You can also test them out, before going to the next step. That can be a small delay from you change the settings until they have effect on the watch.",
            content: {SingleNudgeSettingsView()},
            advanceIntro: advanceIntro)
        
    /*    Heading("Nudge settings")
        Description("Select your preferred settings. You can also test them out, before going to the next step. That can be a small delay from you change the settings until they have effect on the watch. ")
        SingleNudgeSettingsView()
        Button(action: advanceIntro) {
            Text("Next")
        }
*/
    }
}



