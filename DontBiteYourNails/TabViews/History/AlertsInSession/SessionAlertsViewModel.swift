//
//  SessionAlertsViewModel.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 11/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

class SessionAlertsViewModel: ObservableObject {
    @Published var alerts: [Alert] = []
    @Published var sessionTime: String = ""
    @Published var isEditingComment: Bool = false
    @Published var comment: String = ""
    
    @Published var shareFileUrl : URL? = nil
    @Published var urltimestamp: String = ""
    
    private var sessionUpdateObserver: NSObjectProtocol?
    private var nudgeUpdateObserver: NSObjectProtocol?
    
    private var viewContext: NSManagedObjectContext
    
    var session: Session
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(session: Session, viewContext: NSManagedObjectContext) {
        self.session = session
        self.viewContext = viewContext
        
        updateAlerts(from: session)
        updateSessionTime(from: session)
        setupObservers(from: session)
        self.comment = session.comment ?? ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        if session.startTime != nil {
            self.urltimestamp = formatter.string(from: session.startTime!)
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
    
    private func setupObservers(from session: Session) {
        sessionUpdateObserver = NotificationCenter.default.addObserver(
            forName: .sesionUpdated,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateSessionTime(from: session)
        }
        
        nudgeUpdateObserver = NotificationCenter.default.addObserver(
            forName: .nudgesUpdated,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAlerts(from: session)
        }
    }
    
    private func updateAlerts(from session: Session) {
        alerts = (session.primaryAlerts ?? []).sorted { $0.timestamp! > $1.timestamp! }
    }
    
    private func updateSessionTime(from session: Session) {
        if #available(iOS 15.0, *) {
            self.sessionTime = "\(session.startTime!.formatted(date: .abbreviated, time: .shortened)) - \(session.endTime?.formatted(date: .omitted, time: .shortened) ?? "")"
        } else {
            self.sessionTime = ""
        }
    }
    
    func saveComment() {
        session.comment = comment
        do {
            try viewContext.performAndWait {
                // Perform save operation within this block
                if viewContext.hasChanges {
                    try viewContext.save()
                    if SHAREUSAGEDATA{
                        // Task to update comment for Session in Firestore
                        Task { @MainActor in
                            await FirestoreHelper.shared.updateSessionCommentInFirestore(existingSession: session, comment: comment)
                        }
                    }
                }
            }
        } catch {
            // Handle the error as appropriate for your application
            print("Failed to save comment: \(error)")
        }
    }
}
