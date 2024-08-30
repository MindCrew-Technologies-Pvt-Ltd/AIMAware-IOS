//
//  FirstAlertView.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI
import WatchConnectivity

struct FirstNudgeSubflowView: View {
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    @ObservedObject var activeSessionTracker = ActiveSessionTracker.shared
    
    let advanceIntro: () -> Void
    
    var body: some View {
        if (introProgressTracker.hasHadFirstNudge){// todo
            FirstNudgeTriggedView(advanceIntro: advanceIntro)
        } else if (activeSessionTracker.hasActiveSession) {
            TriggerFirstNudgeView(advanceIntro: advanceIntro)
        } else if (introProgressTracker.isWatchAppInstalled) {
            TurnOnSessionView(advanceIntro: advanceIntro)
        } else {
            InstallAppView(advanceIntro: advanceIntro)
        }
    }
}


struct InstallAppView: View {
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    
    let advanceIntro: () -> Void
    
    var body: some View {
        
        SingleIntroductionSlideView(
            title: "Install and open Watch app",
            explanation: "Make sure you have installed AImAware on your Watch and open it. If it is not already installed, you can go to the Watch app on this phone, scroll down to the list of available apps, and find and install AImAware. Then open the app on your watch.",
            content: {SkipFistNudgeFlow(advanceIntro: advanceIntro)},
            advanceIntro: {introProgressTracker.isWatchAppInstalled = true}
            )//nextButton: false)

    }
}


struct TurnOnSessionView: View {
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    
    let advanceIntro: () -> Void
    
    var body: some View {
        
        SingleIntroductionSlideView(
            title: "Start a session",
            explanation: "Press the play button on the watch on AImAware on your watch to get started.",
            content: {SkipFistNudgeFlow(advanceIntro: advanceIntro)},
            advanceIntro: {},
            nextButton: false)

    }
}


struct TriggerFirstNudgeView: View {
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    @ObservedObject var activeSessionTracker = ActiveSessionTracker.shared
    @ObservedObject var settings = PhoneSettings.shared
    
    let advanceIntro: () -> Void
    
    var body: some View {
        
        SingleIntroductionSlideView(
            title: "You can now lift your hand to your head to feel a nudge, and answer on the watch if the nudge is correct",
            explanation: "The watch is set up to be on the \(activeSessionTracker.isLeftHand ?? false ? "left" : "right") hand. If this is not the hand you are using, you can change your settings by going to either settings on your Watch or in the Watch app on your iphone. Then select General -> Direction of watch.",
            content: {SkipFistNudgeFlow(advanceIntro: advanceIntro)},
            advanceIntro: {introProgressTracker.hasHadFirstNudge = true}
        ).onAppear{
            settings.alertDelay = 0
            settings.persistentAlert = true
            settings.alertsOn = true
        }
    }
}

struct FirstNudgeTriggedView: View {
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    
    let advanceIntro: () -> Void
    
    var body: some View {
        
        SingleIntroductionSlideView(
            title: "Congratulation!",
            explanation: "You have started your journey to become more aware of your hand movements. On the watch you can confirm or deny the nudge. This information is used for your statistics. You can also choose not to answer, then the nudge will count as unconfirmed. On the next view you can finetune the nudge settings to your needs, if you want it to only trigger if you keep your hand still for some time or if you want to only get one vibration.",
            content: {SkipFistNudgeFlow(advanceIntro: advanceIntro)},
            advanceIntro: advanceIntro,
            nextButton: true)
    }
}


struct SkipFistNudgeFlow: View {
    let config = Config.shared
    let advanceIntro: () -> Void
    
    var body: some View {
        
        if (config.makeWatchSetupSkipable) {
            Button(action: {
                advanceIntro()
            }) {
                Text("I will use the app without a watch")
            }
        }
    }
}
