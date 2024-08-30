//
//  WatchConnectionNotSupported.swift
//  AImAware
//
//  Created by Sune on 22/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct WatchConnectionNotSupportedView: View {
    
    var body: some View {
        SingleIntroductionSlideView(
            title: "Watch connection not supported",
            explanation: "You are using a device that does not support connection to apple watch. You need an iPhone with a connected Apple Watch to use this app.",
            content: {EmptyView()
                /*Button(action: advanceIntro) {
                Text("Log in (not yet implemented, you just go to next view)")
                }*/
            },
            advanceIntro: {},
            nextButton: false)
    }
}
