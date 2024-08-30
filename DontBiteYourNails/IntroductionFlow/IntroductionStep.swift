//
//  IntroductionStep.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI


enum IntroductionStep: String, CaseIterable {
    case welcome
    //Login flow
    case getUserHeightAgeGender
    case firstAlertView 
        // involves subcases
    case nudgeSettings
    case wantToWorkOnSettings
    case privacySettings
    ///case privacySettingsEmail merged with privacy settings data
    case allowNotifications
    ///case plannedNotifications currently defered
    case lastIntroFlowStep
    
    // Add other steps as needed

    static func nextStep(after currentStep: IntroductionStep) -> IntroductionStep? {
        guard let currentIndex = Self.allCases.firstIndex(of: currentStep),
              currentIndex + 1 < Self.allCases.count else {
            return nil
        }
        return Self.allCases[currentIndex + 1]
    }
    
    @ViewBuilder
    func view(advanceIntro: @escaping () -> Void) -> some View {
        switch self {
        case .welcome:
            WelcomeView(advanceIntro: advanceIntro)
        case .getUserHeightAgeGender:
            GetUserHeightAgeGender(advanceIntro: advanceIntro)
        case .firstAlertView:
            FirstNudgeSubflowView(advanceIntro: advanceIntro)
        case .nudgeSettings:
            NudgeSettingsInIntroFlowView(advanceIntro: advanceIntro)
        case .wantToWorkOnSettings:
            WantToWorkOnSettingsInIntroFlowView(advanceIntro: advanceIntro)
        case .privacySettings:
            PrivacySettingsInIntroFlowView(advanceIntro: advanceIntro)
        case .allowNotifications:
            AllowNotificationsIntroFlowView(advanceIntro: advanceIntro)
        case .lastIntroFlowStep:
            LastIntroFlowView(advanceIntro: advanceIntro)
        }
    }
}


