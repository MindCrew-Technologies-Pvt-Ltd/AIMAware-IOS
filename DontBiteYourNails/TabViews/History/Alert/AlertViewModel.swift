//
//  AlertViewModel.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 14/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//


import SwiftUI
import Combine
import CoreData

@MainActor
class AlertViewModel: ObservableObject {
    @Published var isEditingComment: Bool = false
    @Published var comment: String = ""
    @Published var timestamp: String = ""
    @Published var urltimestamp: String = ""
    @Published var status: String = ""
    @Published var shareFileUrl : URL? = nil
    @Published var feeling : String? = nil
    @Published var urge : Int16? = nil
    @Published var situation : String? = nil
    
    private var viewContext: NSManagedObjectContext
    
    var alert: Alert
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(alert: Alert, viewContext: NSManagedObjectContext) {
        self.alert = alert
        self.viewContext = viewContext
        self.comment = alert.comment ?? ""
        if #available(iOS 15.0, *) {
            self.timestamp = alert.timestamp?.formatted() ?? "unknown"
        } else {
            self.timestamp = "Please update to iOS 15."
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        if alert.timestamp != nil {
            self.urltimestamp = formatter.string(from: alert.timestamp!)
        } else {
            self.urltimestamp = ""
        }
        self.status = alert.status ?? "[error]"
        self.feeling = alert.feeling
        self.urge = alert.urge
        self.situation = alert.situation
    }
    
    func saveComment() {
        alert.comment = comment
        do {
            try viewContext.performAndWait {
                // Perform save operation within this block
                if viewContext.hasChanges {
                    try viewContext.save()
                    if SHAREUSAGEDATA{
                        // Task to update comment for Alert in Firestore
                        Task { @MainActor in
                            await FirestoreHelper.shared.updateAlertCommentInFirestore(alert: alert, comment: comment)
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

