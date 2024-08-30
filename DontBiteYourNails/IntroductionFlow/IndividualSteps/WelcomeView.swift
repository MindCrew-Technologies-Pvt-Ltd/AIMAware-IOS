//
//  WelcomeView.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct WelcomeView: View {
    
    let advanceIntro: () -> Void
    
    var body: some View {
        SingleIntroductionSlideView(
            title: "Welcome to our app. Please log in",
            explanation: "",
            content: {EmptyView()
                /*Button(action: advanceIntro) {
                Text("Log in (not yet implemented, you just go to next view)")
                }*/
            },
            advanceIntro: advanceIntro)
    }
}
