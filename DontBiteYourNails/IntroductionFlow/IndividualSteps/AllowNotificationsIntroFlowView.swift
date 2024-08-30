//
//  FirstAlertView.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct AllowNotificationsIntroFlowView: View {
    
    let advanceIntro: () -> Void
    
    var body: some View {
        SingleIntroductionSlideView(
            title: "Session time limit",
            explanation: "Remember to turn on the session on the watch app to be able to get nudges. The session expires after an hour if you do not interact with the watch app (confirm or deny the nudge or refresh the session). If you enable notifications, the app will notify you just before the session expires.",
            content: {EmptyView()},
            advanceIntro: advanceIntro)

    }
}
