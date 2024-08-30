//
//  DataCollectionView.swift
//  AImAware
//
//  Created by Sune on 07/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct DataCollectionView: View {
    @ObservedObject var settings = PhoneSettings.shared
    
    var body: some View {
        VStack {
            switch settings.selectedSessionType {
            case .majorMovement:
                MajorMovementSessionView()
            case .minorMovement:
                MinorMovementSessionView()
            case .naturalRecorded:
                NaturalRecordedSessionView()
            case .normalUse, .developerSettings:
                NotARecordingSessionView()
            }
        }.id(settings.selectedSessionType)
    }
}


struct NotARecordingSessionView: View {
    var body: some View {
        Text("Please select a recording session type in Settings in order to create a data recording of a standardized type.").font(.title).padding(.all, 16)
        // Your content here
    }
}


struct NaturalRecordedSessionView: View {
    var body: some View {
        VStack{
            Text("You are ready to perform a natural recording").font(.title)
            Text("The alerts will be delayed until either 5 seconds have passed or you have lowered your arm. If the alert would have triggered, you get the usual alert, but delayed. If you lifted your arm but the alert would not have triggered, you get a smaller vibration.").padding(.all, 16)
            Text("When you get an alert, please answer the questions on the watch to confirm/deny the alert. If you only get a smaller alert, you only have to answer if you did touch your head. ").padding(.all, 16)
        }
        // Your content here
    }
}
