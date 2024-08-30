//
//  DashboardData.swift
//  AImAware
//
//  Created by Sune on 18/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct DashboardData {
    var totalDays: Int = 0
    var totalNudges: Int = 0
    var streakLength: Int = 0
    var hadSessionStartedToday: Bool = false
    //var hasHad3Streak: Bool = false // todo
    
}

class DashboardViewModel: ObservableObject {
    @Published var dashboardData = DashboardData()
    @ObservedObject var settings = PhoneSettings.shared
    private var nudgeUpdateObserver: NSObjectProtocol?
    private var activeDateUpdateObserver: NSObjectProtocol?
    
    var topPanelText: String {
        if dashboardData.hadSessionStartedToday {
            if dashboardData.streakLength > 1 {
                return "Great job! You've been using the app \(dashboardData.streakLength) days in a row."
            } else {
                return "You have started a new streak of 1 today! Remember to come back tomorrow to continue it!"
            }
        } else {
            if dashboardData.streakLength > 1 {
                return "You've been using the app the last \(dashboardData.streakLength) days. Make sure to use it today to continue your streak!"
            } else if dashboardData.streakLength == 1 {
                return "You started a new streak yesterday. Make sure to use the app today to continue your streak!"
            } else {
                return "Welcome back! Start a session on the watch to start a new streak."
            }
                    
        }
    }
    
    init() {
        setupObservers()
        refresh()
    }
    
    public func refresh() {
        updateTotalNudges()
        updateStreakLength()
        updateHasSessionToday()
        updateTotalDays()
    }
    
    public func gettingSettingData(){
        DatabaseManager.shared.getUserDetail { userDetail, status in
            if status == 200{
                UserDefaults.standard.set(true, forKey: SharedConstants.alertsOn)
                self.settings.alertsOn = true
                if let delay = userDetail[FireStoreChatConstant.userAlertDelayKey]{
                    UserDefaults.standard.set(delay, forKey: SharedConstants.alertDelayKey)
                    self.settings.alertDelay = delay as? Double ?? 0.0
                    
                }else{
                    UserDefaults.standard.set(0, forKey: SharedConstants.alertDelayKey)
                    self.settings.alertDelay = 0.0
                }
            }
        }
    }
    
    deinit {
        if let observer = nudgeUpdateObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = activeDateUpdateObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func setupObservers() {
        nudgeUpdateObserver = NotificationCenter.default.addObserver(
            forName: .nudgesUpdated,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateTotalNudges()
        }
        
        activeDateUpdateObserver = NotificationCenter.default.addObserver(
            forName: .activeDateUpdated,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateStreakLength()
            self?.updateHasSessionToday()
            self?.updateTotalDays()
        }
        
        
    }
    
    
    func updateTotalNudges() {
        print("total nudges updated")
        DispatchQueue.global(qos: .userInitiated).async {
            let count = CoreDataManager.shared.getNumberOfUndenidedAlerts()
            DispatchQueue.main.async {
                self.dashboardData.totalNudges = count
            }
        }
    }
    
    func updateStreakLength() {
        print("Updating streak length")
        self.dashboardData.streakLength = ActiveDateRepo.shared.getCurrentStreak()
        
    }
    
    func updateHasSessionToday() {
        self.dashboardData.hadSessionStartedToday = ActiveDateRepo.shared.hasSessionToday()
    }
    
    func updateTotalDays() {
        self.dashboardData.totalDays = ActiveDateRepo.shared.getTotalDays()
    }

}
