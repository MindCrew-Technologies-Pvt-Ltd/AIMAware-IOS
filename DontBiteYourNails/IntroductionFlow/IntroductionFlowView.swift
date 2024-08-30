//
//  IntroductionView.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct IntroductionFlowView: View {
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    
    let settings = PhoneSettings.shared
    
    var body: some View {
        if (introProgressTracker.isPaired) {
            introProgressTracker.currentIntroStep.view(advanceIntro: advanceIntro)
        } else if (introProgressTracker.isWatchConnectivitySupported) {
            MakeSureYouHaveAWatchView()
        } else  {
            WatchConnectionNotSupportedView()
        }

    }
    
    private func advanceIntro() {
        introProgressTracker.advanceToNextStep()
    }
}

