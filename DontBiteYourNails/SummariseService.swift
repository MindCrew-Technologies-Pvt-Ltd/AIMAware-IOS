//
//  SummariseService.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 01/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class SummariseService: ObservableObject {
    static let shared = SummariseService()
    
    var config = Config.shared
    
    func totalSessionTimeHHMM(activeDate: ActiveDate) -> String {
        formatTimeInterval(totalSessionTime(activeDate: activeDate))
    }
    
    
    func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: interval) ?? "00:00"
    }
    
    func totalSessionTimePublisher(for activeDate: ActiveDate) -> AnyPublisher<String, Never> {
        return activeDate.objectWillChange
            .map { _ in self.totalSessionTimeHHMM(activeDate: activeDate) }
            .eraseToAnyPublisher()
    }
    
    func totalSessionTime(activeDate: ActiveDate) -> TimeInterval {
        if (activeDate.totalTime != nil && activeDate.totalTime > 0
        ) {
            return activeDate.totalTime
        } else {
            let computedTotalTime = activeDate.sessions?.reduce(0.0) { (result, session) in
                return result + sessionTime(session: session as! Session)
            } ?? 0.0
            
            if(activeDate.date!.addingTimeInterval(2*24*60*60) < Date()) {
                activeDate.totalTime = computedTotalTime
                // Save changes to Core Data context
                do {
                    try activeDate.managedObjectContext?.performAndWait {
                        // Perform save operation within this block
                        if activeDate.managedObjectContext?.hasChanges == true {
                            try activeDate.managedObjectContext?.save()
                            if SHAREUSAGEDATA{
                                // Task to update Total Time for Session in Firestore
                                Task { @MainActor in
                                    await FirestoreHelper.shared.updateTotalTimeforSessionActiveDateInFirestore(activeDateObject: activeDate)
                                }
                            }
                        }
                    }
                } catch {
                    // Handle the error here
                    print("Error saving managed object context: \(error)")
                }
            }
            
            return computedTotalTime
        }
    }
    
    func sessionTime(session: Session) -> TimeInterval {
        (session.endTime ?? Date()).timeIntervalSince(session.startTime ?? Date())
    }
    
    func countAlertsForActiveDate(activeDate: ActiveDate, status: AlertStatusEnum) -> Int {
        guard let sessions = activeDate.sessions else {
            return 0
        }
        
        let totalCount = sessions
            .compactMap { $0 as? Session }
            .map { countAlertsForSession(session: $0, status: status) }
            .reduce(0, +)
        
        return Int(totalCount);
    }
    
    func countAlertsForSession(session: Session, status: AlertStatusEnum) -> Int16 {
        switch (status) {
        case .denied: return countDeniedAlertsForSession(session: session);
        case .ignored: return countIgnoredAlertsForSession(session: session);
        case .confirmed: return countConfirmedAlertsForSession(session: session);
        }
    }
    
    func countDeniedAlertsForSession(session: Session) -> Int16 {
        if (session.denied > 0 && config.allowCachedAlertCount) {// xcode does not respect that the variable should be optional, so I have to treat 0 as nil.
            return session.denied;
        } else {
            let counted = countAlertsForSessionUncached(session: session, status: .denied)
            if (session.endTime != nil) {
                session.denied = counted
                // Save changes to Core Data context
                do {
                    try session.managedObjectContext?.performAndWait {
                        // Perform save operation within this block
                        if session.managedObjectContext?.hasChanges == true {
                            try session.managedObjectContext?.save()
                            if SHAREUSAGEDATA {
                                // Task to create denied count for Session in Firestore
                                Task { @MainActor in
                                    await FirestoreHelper.shared.updateSessionCountInFirestore(existingSession: session, sessionDenied: true)
                                }
                            }
                        }
                    }
                } catch {
                    // Handle the error here
                    print("Error saving managed object context: \(error)")
                }
            }
            
            return counted
        }
    }
    
    func countIgnoredAlertsForSession(session: Session) -> Int16 {
        if (session.ignored > 0 && config.allowCachedAlertCount) {// xcode does not respect that the variable should be optional, so I have to treat 0 as nil.
            return session.ignored;
        } else {
            let counted = countAlertsForSessionUncached(session: session, status: .ignored)
            if (session.endTime != nil) {
                session.ignored = counted
                // Save changes to Core Data context
                do {
                    try session.managedObjectContext?.performAndWait {
                        // Perform save operation within this block
                        if session.managedObjectContext?.hasChanges == true {
                            try session.managedObjectContext?.save()
                            if SHAREUSAGEDATA{
                                // Task to create ignored count for Session in Firestore
                                Task { @MainActor in
                                    await FirestoreHelper.shared.updateSessionCountInFirestore(existingSession: session, sessionIgnored: true)
                                }
                            }
                        }
                    }
                } catch {
                    // Handle the error here
                    print("Error saving managed object context: \(error)")
                }
            }
            
            return counted
        }
    }
    
    func countConfirmedAlertsForSession(session: Session) ->Int16 {
        if (session.confirmed > 0 && config.allowCachedAlertCount) {// xcode does not respect that the variable should be optional, so I have to treat 0 as nil.
            return session.confirmed;
        } else {
            let counted = countAlertsForSessionUncached(session: session, status: .confirmed)
            if (session.endTime != nil) {
                session.confirmed = counted
                // Save changes to Core Data context
                do {
                    try session.managedObjectContext?.performAndWait {
                        // Perform save operation within this block
                        if session.managedObjectContext?.hasChanges == true {
                            try session.managedObjectContext?.save()
                            if SHAREUSAGEDATA{
                                // Task to create confirmed count for Session in Firestore
                                Task { @MainActor in
                                    await FirestoreHelper.shared.updateSessionCountInFirestore(existingSession: session, sessionConfirmed: true)
                                }
                            }
                        }
                    }
                } catch {
                    // Handle the error here
                    print("Error saving managed object context: \(error)")
                }
            }
            
            return counted
        }
    }
    
    func countAlertsForSessionUncached(session: Session, status: AlertStatusEnum) -> Int16 {
        return Int16(session.primaryAlerts?
            .filter{alert in alert.status == status.stringValue}
            .count ?? 0)
    }
    /*
    func getAlertsForActiveDate(activeDate: ActiveDate, filter: ((Alert) -> Bool)? = nil) -> [Alert] {
        var allAlerts = activeDate.sessions?.compactMap { ($0 as? Session)?.alerts?.allObjects as? [Alert] }
            .flatMap { $0 } ?? []
        
        if let filter = filter {
            allAlerts = allAlerts.filter(filter)
        }
        
        return allAlerts
    }*/
}
