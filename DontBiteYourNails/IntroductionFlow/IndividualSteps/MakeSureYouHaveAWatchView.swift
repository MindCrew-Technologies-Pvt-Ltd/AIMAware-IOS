//
//  WatchConnectionNotSupported.swift
//  AImAware
//
//  Created by Sune on 22/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct MakeSureYouHaveAWatchView: View {
    
    var body: some View {
        SingleIntroductionSlideView(
            title: "No connected Watch",
            explanation: "In order to use this app, you need to have a connected Apple Watch. Please set that up before setting up this app.",
            content: {EmptyView()},
            advanceIntro: {},
            nextButton: false)
    }
}
