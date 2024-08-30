//
//  SessionMotionDataRepo.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 07/09/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import CoreData

class SessionMotionDataRepo {
    static let shared = SessionMotionDataRepo()
    
    var coreDataManager = CoreDataManager.shared
    
    func addSessionMotionData(_ persistentContainer: NSPersistentContainer, _ timestamp: Date, _ sessionId: String, _ data: String) {
        let managedObjectContext = persistentContainer.viewContext
        
        if let sessionMotionData = NSEntityDescription.insertNewObject(forEntityName: "SessionMotionData", into: managedObjectContext) as? SessionMotionData {
            
            sessionMotionData.timestamp = timestamp
            
            let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", sessionId as CVarArg)
            
            
            let encoder = JSONEncoder()
            do {
                sessionMotionData.data = "|" + String(data:try encoder.encode(ExportableMotionData(from: data)), encoding: .utf8)! + "|"
            } catch {
                sessionMotionData.data = "Encoding failed"
            }
            
            do {
                
                let context = coreDataManager.viewContext
                // Fetch the existing object with the given ID
                let existingSession = try context.fetch(fetchRequest).first
                
                sessionMotionData.session = existingSession
            } catch{
                print("Failed to set session")
            }
            do {
                try managedObjectContext.performAndWait {
                    // Perform save operation within this block
                    if managedObjectContext.hasChanges {
                        try managedObjectContext.save()
                        NotificationCenter.default.post(name: .sesionUpdated, object: nil)
                        print("New session recording piece added successfully.")
                        if SHAREUSAGEDATA{
                            // Task to update Session Motion Data for Session in Firestore
                            Task { @MainActor in
                                await FirestoreHelper.shared.updateSessionMotionDataForSessionInFirestore(sessionMotionData: sessionMotionData)
                            }
                        }
                    }
                }
            } catch {
                print("Failed to save session recording piece: \(error)")
            }
            
        } else {
            print("Couldn't get session recording piece")
        }
    }
}
