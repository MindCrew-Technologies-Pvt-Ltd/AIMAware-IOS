//
//  PhoneWatchConnectionService.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 30/07/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class PhoneWatchConnectionService {
    
    var coreDataManager = CoreDataManager.shared
    let handleAlertInfo = HandleAlertInfo()
    let handleSessionInfo = HandleSessionInfo()
    let handleSessionRecording = HandleSessionRecording()
    
    func handleUserInfo(userInfo: [String : Any], persistentContainer : NSPersistentContainer) {
        print("UserInfo received")
        if let entityType = userInfo["entityType"] as? String {
            switch entityType {
            case SharedConstants.alert: handleAlertInfo.handleUserInfoAlert(userInfo: userInfo, persistentContainer: persistentContainer)
            case SharedConstants.session: handleSessionInfo.handleUserInfoSession(userInfo: userInfo, persistentContainer: persistentContainer)
            case SharedConstants.sessionRecording: handleSessionRecording.handleUserInfoSession(userInfo: userInfo, persistentContainer: persistentContainer)
            case SharedConstants.mlCall: handleMlCall(userInfo: userInfo, persistentContainer: persistentContainer)
            default:
                print("Failed to handle userInfo because entitytype  \(entityType) is unknown")
                print("Entire content: \(userInfo)")
            }
        } else {
            print("Entity type missing. Total userinfo: \(userInfo)")
        }
    }

    
    // only relevant for development app so not put in separate class:
    func handleMlCall(userInfo: [String : Any], persistentContainer : NSPersistentContainer) {
        print("MLcall recording received")
        if let sessionId = userInfo[SharedConstants.sessionId] as? String,
           let input = userInfo[SharedConstants.input] as? [Double],
           let output = userInfo[SharedConstants.output] as? [Double],
           let model = userInfo[SharedConstants.model] as? String,
           let timeArrayArray = userInfo[SharedConstants.timeArray] as? [[String: Any]] {
            
            let timeArray = timeArrayArray.compactMap { (dict) -> (String, Double)? in
                if let firstElement = dict["firstElement"] as? String,
                   let secondElement = dict["secondElement"] as? Double {
                    return (firstElement, secondElement)
                }
                return nil
            }
            let timeDictionary: [String: Double] = timeArray.reduce(into: [:]) { dict, tuple in
                dict[tuple.0] = tuple.1
            }
            
            
            print("New mlCall of type \(model) recieved.")
            print_timearray(timearray: timeArray)
            print("Probability: \(output)")
            
            
            let managedObjectContext = persistentContainer.viewContext
         
            if let mlCall = NSEntityDescription.insertNewObject(forEntityName: "MlCall", into: managedObjectContext) as? MlCall {
                
                
                mlCall.features = input.map { String($0) }.joined(separator: ", ")
                mlCall.outputString = output.map { String($0) }.joined(separator: ", ")
                mlCall.modelType = model
                mlCall.timeDone = Date.init(timeIntervalSinceReferenceDate: timeArray[timeArray.count - 1].1)
                mlCall.beforeTime = Date.init(timeIntervalSinceReferenceDate: timeArray[0].1)
                mlCall.featuresCalculatedTime = Date.init(timeIntervalSinceReferenceDate: timeDictionary["Input created"] ?? 0)
                
                let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", sessionId as CVarArg)
                
                do {
                    let context = coreDataManager.viewContext
                    // Fetch the existing object with the given ID
                    let existingSession = try context.fetch(fetchRequest).first
                    
                    mlCall.session = existingSession
                } catch{
                    print("Failed to set session on mlCall")
                }
                
                do {
                    try managedObjectContext.performAndWait {
                        // Perform save operation within this block
                        if managedObjectContext.hasChanges {
                            try managedObjectContext.save()
                            print("New mlCall of type \(model) added successfully.")
                            print_timearray(timearray: timeArray)
                            print("Probability: \(output)")
                            if SHAREUSAGEDATA{
                                // Task to create ML Call for Existing Session in Firestore
                                Task { @MainActor in
                                    await FirestoreHelper.shared.createSessionMLCallInFirestore(mlCall: mlCall)
                                }
                            }
                        }
                    }
                } catch {
                    print("Failed to save the context for RnnMlCall: \(error)")
                }
            }
        } else {
            print("Failed to handle userInfo about rnnmlcall recording. Keys: \(userInfo.keys)")
        }
    }
    
    
    
    func print_timearray(timearray: [(String, Double)]) {
        for i in 0..<(timearray.count - 1) {
            let firstEvent = timearray[i]
            let secondEvent = timearray[i+1]
            
            let firstString = firstEvent.0
            let firstTime = firstEvent.1
            
            let secondString = secondEvent.0
            let secondTime = secondEvent.1
            
            let timeDifference = secondTime - firstTime
            
            print("Time between \(firstString) and \(secondString): \(timeDifference) seconds")
        }
        print("Total time spend: \(timearray[timearray.count - 1].1 - timearray[0].1)")
    }
}

