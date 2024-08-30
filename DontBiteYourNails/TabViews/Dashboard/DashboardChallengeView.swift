//
//  DashboardChallengeView.swift
//  AImAware
//
//  Created by Sune on 14/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI


struct DashboardChallengeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.dashboardData.streakLength < 3 {
                BodyText("Your first challenge: turn on the app for 3 days in a row!")
                    .padding(20).frame(maxWidth: .infinity)
            } else if viewModel.dashboardData.streakLength < 7 {
                BodyText("Can you get a one week streak?")
                    .padding(20).frame(maxWidth: .infinity)
            } else if viewModel.dashboardData.streakLength < 30 {
                BodyText("Final challenge, can you get a 30 day streak?")
                    .padding(20).frame(maxWidth: .infinity)
            } else {
                BodyText("Your have completed all our challenges! Keep going!")
                    .padding(20).frame(maxWidth: .infinity)
            }
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding(25)
    }
}
