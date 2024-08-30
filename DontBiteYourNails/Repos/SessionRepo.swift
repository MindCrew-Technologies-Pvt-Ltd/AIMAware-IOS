//
//  SessionRepo.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 07/09/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import CoreData

class SessionRepo {
    static var shared = SessionRepo()
    
    var coreDataManager = CoreDataManager.shared
    var activeDateRepo = ActiveDateRepo.shared
    
    
    func getActiveSession(deviceType: String) -> Session? {
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        let predicate = NSPredicate(format: "endTime == nil AND deviceType == %@", deviceType)
        fetchRequest.predicate = predicate
        do {
            let sessions = try coreDataManager.viewContext.fetch(fetchRequest)
            if (sessions.count > 1) {
                print("Found \(sessions.count) session")
                return nil
            } else if (sessions.count == 1) {
                return sessions.first
            } else {
                print("No active session found")
                return nil
            }
        } catch {
            print("Failed at finding or not finding active session")
            return nil
        }
    }
    
    func createSession(_ persistentContainer: NSPersistentContainer, _ timestamp: Date, _ id: String, _ isLeftHand: Bool?, deviceType: String, deviceId: String) {
        ActiveSessionTracker.shared.hasActiveSession = true
        ActiveSessionTracker.shared.isLeftHand = isLeftHand
        let managedObjectContext = persistentContainer.viewContext
        
        let session = NSEntityDescription.insertNewObject(forEntityName: "Session", into: managedObjectContext)
        
        let activeDate = activeDateRepo.fetchOrCreateActiveDate(date: activeDateRepo.getDateWithoutTime(dateWithTime: timestamp), persistentContainer: persistentContainer)
        
        let uuid = UUID(uuidString: id)
        
        session.setValue(uuid, forKey : "id")
        session.setValue(timestamp, forKey : "startTime")
        session.setValue(isLeftHand, forKey : "isLeftHand")
        session.setValue(timestamp, forKey : "lastRefresh")
        session.setValue(activeDate, forKey: "date")
        session.setValue(deviceType, forKey: "deviceType")
        session.setValue(deviceId, forKey: SharedConstants.deviceId)
        
        do {
            try managedObjectContext.performAndWait {
                // Perform save operation within this block
                if managedObjectContext.hasChanges {
                    try managedObjectContext.save()
                    print("New session added successfully.")
                    guard let uuid = uuid else{
                        print("UUID is empty so data can't be stored in Firestore")
                        return
                    }
                    if SHAREUSAGEDATA{
                        // Task to create session in Firestore with start time and other details
                        Task { @MainActor in
                            await FirestoreHelper.shared.createSessionInFirestore(timestamp: timestamp, id: uuid, isLeftHand: isLeftHand, deviceType: deviceType, deviceId: deviceId, activeDateObject: activeDate)
                        }
                    }
                }
            }
        } catch {
            print("Failed to save the context: \(error)")
        }
    }
    
    func endSessionNow(id: String) {
        ActiveSessionTracker.shared.hasActiveSession = false
        updateSession(id: id, timestamp: Date(), action: SessionActionEnum.end.stringValue)
    }
    
    func updateSession(id: String, timestamp: Date, action: String) {
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let context = coreDataManager.viewContext
            // Fetch the existing object with the given ID
            let existingSession = try context.fetch(fetchRequest).first
            
            // If the object is found, update its attributes
            if let existingSession = existingSession {
                existingSession.lastRefresh = timestamp
                if (SessionActionEnum.end.stringValue == action) {
                    existingSession.endTime = timestamp
                }
                
                try context.performAndWait {
                    // Perform save operation within this block
                    if context.hasChanges {
                        // Save the changes to the persistent store
                        try context.save()
                        NotificationCenter.default.post(name: .sesionUpdated, object: nil)
                        if SHAREUSAGEDATA{
                            // Task to update session in Firestore with end time
                            Task { @MainActor in
                                await FirestoreHelper.shared.updateSessionTimeInFirestore(existingSession: existingSession)
                            }
                        }
                    }
                }
            }
            print("Session updated successfully.")
        } catch {
            print("Error updating element: \(error)")
        }
    }
    
    func endUnendedSessions(persistentContainer : NSPersistentContainer, deviceType: String, deviceId: String) {
        print("End all unendedSessions if any")
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        let predicate = NSPredicate(format: "endTime == nil AND deviceType == %@ AND deviceId == %@", deviceType, deviceId)
        fetchRequest.predicate = predicate
        
        do {
            // Fetch all sessions
            let sessions = try coreDataManager.viewContext.fetch(fetchRequest)
            print("Ending \(sessions.count) sessions")
            // Loop through each session
            for session in sessions {
                // Calculate the maximum timestamp from its associated alerts
                let maxAlertTime = session.alerts?.compactMap { ($0 as! Alert).timestamp }.max()
                
                // Calculate the maximum between lastRefresh and maxTimestamp
                let constructedEndTime = max(session.lastRefresh ?? session.startTime!, maxAlertTime ?? session.startTime!)
                
                // Set the calculated endTime
                session.endTime = constructedEndTime
                
                if SHAREUSAGEDATA{
                    // Task to update session in Firestore with end time
                    Task { @MainActor in
                        await FirestoreHelper.shared.updateSessionTimeInFirestore(existingSession: session)
                    }
                }
            }
            
            try coreDataManager.viewContext.performAndWait {
                // Perform save operation within this block
                if coreDataManager.viewContext.hasChanges {
                    // Save the context to persist the changes
                    try coreDataManager.viewContext.save()
                    NotificationCenter.default.post(name: .sesionUpdated, object: nil)
                }
            }
            
        } catch {
            // Handle the error gracefully
            print("Error updating endTime for sessions: \(error)")
        }
        
    }
    
    
    
}
