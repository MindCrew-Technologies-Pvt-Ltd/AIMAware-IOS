//
//  HandleAlerts.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 19/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import CoreData

class HandleAlertInfo {
    
    var coreDataManager = CoreDataManager.shared
    
    
    func handleUserInfoAlert(userInfo: [String : Any], persistentContainer : NSPersistentContainer) {
        IntroProgressTracker.shared.hasHadFirstNudge = true
        print("UserInfo about alert received")
        if let status = userInfo["status"] as? String,
           let sessionId = userInfo["sessionId"] as? String,
           let isSecondaryAlert = userInfo[SharedConstants.isSecondaryAlert] as? Bool,
           let userAlerted = userInfo[SharedConstants.userAlerted] as? Bool,
           let handStillNearPosition = userInfo[SharedConstants.handStillNearPosition] as? Bool,
           let userAnswers = userInfo[SharedConstants.userAnswers] as? [String],
           let specificAreaGivenByUser = userInfo[SharedConstants.specificAreaGivenByUser] as? Int,
           let timestamp = userInfo["timestamp"] as? Date {
            print("Recieved alert with timestamp \(timestamp) and status \(status)")
            //print("Motion data of size : \(data.count) bytes")
            //print("Last motion data of size : \(lastData.count) bytes")
            //print("Last motion data: \(lastData)")
            print("User answers: \(userAnswers)")
            
            let managedObjectContext = persistentContainer.viewContext
            
            if let alert = NSEntityDescription.insertNewObject(forEntityName: "Alert", into: managedObjectContext) as? Alert {
                
                alert.id = UUID()
                alert.timestamp = timestamp
                alert.status = status
                alert.secondary = isSecondaryAlert
                alert.userAlerted = userAlerted
                alert.handStillNearPosition = handStillNearPosition
                
                
                let userAnswerDict = extractUserAnswerDict(userAnswers: userAnswers)
                let userAnswersString = userAnswers.map{String($0)}.joined(separator: ",")
                alert.userAnswers = String(specificAreaGivenByUser) + "," + userAnswersString
                
                if let correctnessAnswer = userAnswerDict[SharedConstants.correctQuestionId] {
                    if (correctnessAnswer == SharedConstants.thumpsUp) {
                        alert.status = SharedConstants.confirmed
                    } else {
                        alert.status = SharedConstants.denied
                    }
                } else {
                    alert.status = SharedConstants.ignored
                }
                
                alert.feeling = userAnswerDict[SharedConstants.feelingQuestionId]
                
                if let stringUrge = userAnswerDict[SharedConstants.urgeQuestionId],
                   let intUrge = Int16(stringUrge) {
                    alert.urge = intUrge
                }
                
                alert.situation = userAnswerDict[SharedConstants.situationQuestionId]
                
                let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", sessionId as CVarArg)
                
                if let alertMotionData = NSEntityDescription.insertNewObject(forEntityName: "AlertMotionData", into: managedObjectContext) as? AlertMotionData {
                    let encoder = JSONEncoder()
                    /*  do {
                     alertMotionData.data = "|" + String(data:try encoder.encode(ExportableMotionData(from: data)), encoding: .utf8)! + "|"
                     } catch {
                     alertMotionData.data = "Encoding failed"
                     }*/
                    alertMotionData.type = "active"
                    alert.addToAlertMotionData(alertMotionData)
                }
                
                /*       if lastData != "", let calibrationMotionData = NSEntityDescription.insertNewObject(forEntityName: "AlertMotionData", into: managedObjectContext) as? AlertMotionData {
                 let encoder = JSONEncoder()
                 do {
                 calibrationMotionData.data = "|" + String(data: try encoder.encode(ExportableMotionData(from: lastData)), encoding: .utf8)!
                 + "|"
                 } catch {
                 calibrationMotionData.data = "Encoding failed"
                 }
                 calibrationMotionData.type = "calibration"
                 alert.addToAlertMotionData(calibrationMotionData)
                 }*/
                
                do {
                    
                    let context = coreDataManager.viewContext
                    // Fetch the existing object with the given ID
                    let existingSession = try context.fetch(fetchRequest).first
                    
                    alert.session = existingSession
                } catch{
                    print("Failed to set session")
                }
                
                do {
                    try managedObjectContext.performAndWait {
                        // Perform save operation within this block
                        if managedObjectContext.hasChanges {
                            try managedObjectContext.save()
                            NotificationCenter.default.post(name: .nudgesUpdated, object: nil)
                            print("New alert added successfully.")
                            if SHAREUSAGEDATA{
                                // Task to create alert for Session in Firestore
                                Task { @MainActor in
                                    await FirestoreHelper.shared.createSessionAlertInFirestore(alert: alert)
                                }
                            }
                        }
                    }
                } catch {
                    // Handle error
                    print("Error saving managed object context: \(error)")
                }
            } else {
                print("Couldn't get alert")
            }
            
        } else {
            print("Failed to handle userInfo about alert. Useinfo: \(userInfo)")
        }
    }
    
    func extractUserAnswerDict(userAnswers: [String]) -> [Int: String] {
        var dict = [Int: String]()

        for item in userAnswers {
            let components = item.components(separatedBy: ":")
            guard components.count == 2, let key = Int(components[0]) else {
                print("Warning: Ignoring invalid item '\(item)'")
                continue
            }

            if dict.keys.contains(key) {
                print("Warning: repeated key '\(key)'")
            }

            dict[key] = components[1]
        }

        return dict
    }
}
