//
//  CommonDataCollectionSessionViews.swift
//  AImAware
//
//  Created by Sune on 09/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct CommonNoSessionView: View {
    var buttonAction: () -> Void

    var body: some View {
        VStack {
            Text("The watch does not have an active session. Make sure to start one and press the button below.")
                .font(.title).padding(.all, 16)
            Text("It usually takes at most a few seconds from you start the session on the watch until the phone has registered...")
                .padding(.all, 16)
            Button(action: buttonAction) {
                Text("Done!").font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}
