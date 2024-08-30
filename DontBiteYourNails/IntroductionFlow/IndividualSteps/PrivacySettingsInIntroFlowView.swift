//
//  PrivacyDataSettingsInIntroFlowView.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct PrivacySettingsInIntroFlowView: View {
    
    let advanceIntro: () -> Void
    
    var body: some View {
        SingleIntroductionSlideView(
            title: "Privacy settings",
            explanation: "In order to improve the app, to create more specific targets it would be helpful if you want to share some data with us.",
            content: {PrivacyDataSettingsView()
                PrivacyEmailSettingsView()},
            advanceIntro: advanceIntro
        )

    }
}

