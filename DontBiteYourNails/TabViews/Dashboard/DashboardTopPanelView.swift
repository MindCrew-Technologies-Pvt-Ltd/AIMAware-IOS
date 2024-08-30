//
//  DashboardTopPanelView.swift
//  AImAware
//
//  Created by Sune on 14/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI


struct DashboardTopPanelView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                HStack{
                    //Text("Hello Name")
                    Text("Dashboard")
                        .font(.title3)
                        .foregroundColor(Color.white)
                        .fontWeight(.medium)// 500
                    Spacer()
                }
                .padding(.leading, 25)
                .padding(.bottom, 20)
                .padding(.top, 20)
                HStack{
                    Text("\(viewModel.dashboardData.streakLength)")
                        .font(.system(size: 40))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)// 500
                        .padding()
                        .frame(minWidth: 80)
                        .background(Color("TopFadeColor")) // Set the background color
                        .cornerRadius(16)
                    Spacer()
                }
                .padding(.leading, 25)
                .padding(.bottom, 20)
                HStack{
                    Text(viewModel.topPanelText)
                        .foregroundColor(Color.white)
                        .fontWeight(.medium)// 500
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 80)
                }
                .padding(.leading, 25)
                .padding(.bottom, 25)
            }
        }
        .background(GradientBackgroundView().edgesIgnoringSafeArea(.all))
    }
}
