//
//  IntroProgressTracker.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import WatchConnectivity
import UserNotifications

class IntroProgressTracker: ObservableObject {
    
    static let shared = IntroProgressTracker()
    let isWatchConnectivitySupported = WCSession.isSupported()
    @Published var isPaired: Bool = false
    @Published var isWatchAppInstalled: Bool = false
    @Published var hasHadFirstNudge = false
    
    //For signup views navigation
    @Published var fromWhereToNavigate: String = ""
    @Published var introWeekDayArr: [Weekdays] = []
    @Published var introReminderData: [String:Any] = [:]
    @Published var getReminderTime: TimeInterval = 0.0
    
    private var session: WCSession? {
        WCSession.isSupported() ? WCSession.default : nil
    }

    func updateWatchAppInstalledStatus() {
        DispatchQueue.main.async {
            self.isWatchAppInstalled = self.session?.isWatchAppInstalled ?? false
            self.isPaired = self.session?.isPaired ?? false
            
        }
    }
    
    func getSessionReachability(message: [String: Any]) {
        DispatchQueue.main.async {
            if ((self.session?.isReachable) != nil){
                self.session?.sendMessage(message, replyHandler: nil, errorHandler: { error in
                    print("Error sending message to watch: \(error.localizedDescription)")
                })
            }else{
                print("")
            }
        }
    }
    
    @Published var hasCompleteIntro = UserDefaults.standard.bool(forKey: SharedConstants.hasCompleteIntro) {
        didSet {
            UserDefaults.standard.set(hasCompleteIntro, forKey: SharedConstants.hasCompleteIntro)
        }
    }
    @Published var currentIntroStep = IntroductionStep(rawValue: UserDefaults.standard.string(forKey: SharedConstants.currentIntroStep) ?? "") ?? IntroductionStep.welcome  {
        didSet {
            UserDefaults.standard.set(currentIntroStep.rawValue, forKey: SharedConstants.currentIntroStep)
        }
    }
    
    @Published var isUserLoggedIn: Bool = false
    @Published var isSavedDataToFB: Bool = false
    
    
    func advanceToNextStep() {
        if let nextStep = IntroductionStep.nextStep(after: self.currentIntroStep) {
            currentIntroStep = nextStep
        } else {
            hasCompleteIntro = true
        }
    }
}
