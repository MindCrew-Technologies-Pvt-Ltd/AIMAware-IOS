//
//  Dashboard2.swift
//  AImAware
//
//  Created by Sune on 07/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            DashboardTopPanelView()
            DashboardChallengeView()
            DashboardStatsView()
            //ManuelRegistrationBarView()
            Spacer()

        }.background(Color("BackgroundColor"))
            .onAppear {
                AnalyticsHelper.logCreatedEvent(key: "view_home", value: SignUpCompleteViewModel.shared.getCurrentUserId() ?? "")
                viewModel.refresh()
                viewModel.gettingSettingData()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                viewModel.refresh()
            }
    }
}
