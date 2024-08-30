//
//  SingleIntroductionSlideView.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct SingleIntroductionSlideView<Content: View>: View {
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    let config = Config.shared
    
    var title: String
    var explanation: String
    var content: Content
    var advanceIntro: () -> Void
    var nextButton: Bool
    
    init(title: String, explanation: String, @ViewBuilder content: () -> Content, advanceIntro: @escaping () -> Void, nextButton: Bool = true) {
        self.title = title
        self.explanation = explanation
        self.content = content()
        self.advanceIntro = advanceIntro
        self.nextButton = nextButton
    }
    
    var body: some View {
        Spacer()
        Heading(title)
        BodyText(explanation)
        content
        if(nextButton) {
            Button(action: advanceIntro) {
                Text("Next")
            }
        }
        Spacer()
        if(config.makeIntroflowSkipable) {
            Button(action: {
                introProgressTracker.hasCompleteIntro = true
            }) {
                Text("Skip intro")
            }
        }
    }
}
