//
//  EventManager.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 03/09/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import CoreData

class EventService {
    static let shared = EventService()
    let sessionsRepo = SessionRepo.shared
    
    var coreDataManager = CoreDataManager.shared
    
    /*
     * Returns false if there is no active session.
     */
    func recordEvent(type : String) -> Bool {
            print("Recording event of type \(type)")

        let managedObjectContext = coreDataManager.persistentContainer.viewContext
                
        if let event = NSEntityDescription.insertNewObject(forEntityName: "SjEvent", into: managedObjectContext) as? SjEvent {
            event.timestamp = Date()
            event.type = type
            
            event.session = sessionsRepo.getActiveSession(deviceType: SharedConstants.watch)
            
            do {
                try managedObjectContext.performAndWait {
                    // Perform save operation within this block
                    if managedObjectContext.hasChanges {
                        try managedObjectContext.save()
                        print("Event succesfully saved.")
                        if SHAREUSAGEDATA{
                            // Task to create SjEvent for Session in Firestore
                            Task { @MainActor in
                                await FirestoreHelper.shared.createSessionSjEventInFirestore(sjEvent: event)
                            }
                        }
                    }
                }
            } catch {
                print("Failed to save event: \(error)")
            }
            return event.session != nil
        }
        return false
    }
}
