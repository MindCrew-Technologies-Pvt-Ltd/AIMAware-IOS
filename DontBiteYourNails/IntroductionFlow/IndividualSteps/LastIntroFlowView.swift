//
//  FirstAlertView.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct LastIntroFlowView: View {
    
    let advanceIntro: () -> Void
    
    var body: some View {
        SingleIntroductionSlideView(
            title: "You are all set up and ready to improve your habits!",
            explanation: "",
            content: {EmptyView()},
            advanceIntro: advanceIntro)

    }
}
