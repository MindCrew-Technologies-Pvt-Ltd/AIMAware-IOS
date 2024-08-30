//
//  WelcomePageView.swift
//  AImAware
//
//  Created by Suyog on 18/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct WelcomePageView: View {
    @State private var showTutorialView = false
    @EnvironmentObject var router : NavigationRouter
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    @State var selection: Int? = nil
    @ObservedObject var settings = PhoneSettings.shared
    var body: some View {
        VStack {
            Image("Group")
                .padding(.top, 150.0)
            Text("AlmAware")
                .padding(.top, 10.0).font(.setCustom(fontStyle: .title, fontWeight: .heavy))
                .padding(.bottom).foregroundColor(Color(red: 66/255, green: 165/255, blue: 255/255))
            Text("Welcome")
                .padding(.top, 60.0).font(.setCustom(fontStyle: .largeTitle, fontWeight: .medium))
                .padding(.bottom)
            
            Text("Your companion app supporting you beat stress, anxiety and bad habits")
                .multilineTextAlignment(.center)
                .font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                .padding(.horizontal, 80.0)
            Spacer()
            
            Button {
                showTutorialView = true
                USER_DEFAULTS.set(true, forKey: FROMWELCOMEPAGE)
                router.navigate(to: .tutorialView)
                //router.navigate(to: .reminderView)
            } label: {
                Text("Start here")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("MiddleFadeColor2"))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                
            }
            .padding()
            
        }.onAppear{
            settings.alertDelay = 0
            settings.alertsOn = true
        }
        .background(Color("BackgroundColor"))//
    }
}

#Preview {
    WelcomePageView()
}
