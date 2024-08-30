//
//  DaysSessionViewModel.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 11/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import Combine
import CoreData

class DaySessionsViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var dayStamp: String = ""
    @Published var shareFileUrl : URL? = nil
    @Published var urltimestamp: String = ""
    
    private var sessionUpdateObserver: NSObjectProtocol?
    private var nudgeUpdateObserver: NSObjectProtocol?

    var activeDate : ActiveDate

    init(activeDate: ActiveDate) {
        self.activeDate = activeDate

        updateDayStamp(from: activeDate)
        updateSessions(from: activeDate)
        updateDayStamp(from: activeDate)
        setupObservers(from: activeDate)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        if activeDate.date != nil {
            self.urltimestamp = formatter.string(from: activeDate.date!)
        } else {
            self.urltimestamp = ""
        }
    }
    
    deinit {
        if let observer = sessionUpdateObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = nudgeUpdateObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func updateSessions(from activeDate: ActiveDate) {
        sessions = (activeDate.sessions?.allObjects as? [Session] ?? []).sorted { $0.startTime! > $1.startTime! }
    }
    
    private func updateDayStamp(from activeDate: ActiveDate) {
        if #available(iOS 15.0, *) {
            dayStamp = "\(activeDate.date!.formatted(date: .long, time: .omitted))"
        } else {
            dayStamp = ""
        }
    }
    
    
    private func setupObservers(from activeDate: ActiveDate) {
        sessionUpdateObserver = NotificationCenter.default.addObserver(
            forName: .sesionUpdated,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateSessions(from: activeDate)
        }
        nudgeUpdateObserver = NotificationCenter.default.addObserver(
            forName: .nudgesUpdated,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateSessions(from: activeDate)
        }
    }
}
