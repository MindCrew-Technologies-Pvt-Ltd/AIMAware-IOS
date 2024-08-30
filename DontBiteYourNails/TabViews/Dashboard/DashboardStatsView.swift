//
//  DashboardStatsView.swift
//  AImAware
//
//  Created by Sune on 14/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct DashboardStatsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack{
            HStack(spacing: 0){
                VStack(alignment: .leading) {
                    Text("\(viewModel.dashboardData.totalDays)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("MainTextColor"))
                    Footnote("Number of days you've used the app.")
                }.padding(8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(MinorWhiteBackgroundView())
                    .padding(8)
                    .padding(.top, 31 - 8)
                    .padding(.bottom, 12 - 8)
                    .background(MinorGradientBackgroundView(endPoint: .bottom))
                    .padding(.trailing, 8)
                
                VStack(alignment: .leading) {
                    Text("\(viewModel.dashboardData.totalNudges)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("MainTextColor"))
                    Footnote("Nudges that have helped you change your habits")
                }.padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(MinorWhiteBackgroundView())
                .padding(8)
                .padding(.top, 31 - 8)
                .padding(.bottom, 12 - 8)
                .background(MinorGradientBackgroundView2())
                .padding(.leading, 8)
                .frame(maxWidth: .infinity)
                
            }.frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)
        }.padding(.leading, 25)// end of HStack
            .padding(.trailing, 25)
    }
}
