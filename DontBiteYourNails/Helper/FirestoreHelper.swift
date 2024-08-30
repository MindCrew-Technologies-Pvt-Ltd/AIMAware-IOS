//
//  FirestoreHelper.swift
//  AImAware
//
//  Created by Maulik Bhuptani on 01/03/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FirestoreHelper {
    static let shared = FirestoreHelper()
    private var db: Firestore!
    
    private var usersCollection = "users"
    private var alertsCollection = "alerts"
    private var totalTimeCollection = "totalTime"
    
    private var activeDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }
    
    private init(){}
    
    public func initializeFirestore() {
        db = Firestore.firestore()
    }
    
    public func createSessionInFirestore(timestamp: Date, id: UUID, isLeftHand: Bool?, deviceType: String, deviceId: String, activeDateObject: ActiveDate) async {
        guard let uID = USER_DEFAULTS.value(forKey: USERID) else{
            return
        }
        //let uID = USER_DEFAULTS.value(forKey: USERID) as! String
        let activeDateString = activeDateFormatter.string(from: activeDateObject.date ?? Date())
        let sessionId = id.uuidString
        
        let activeDateDictionary: [String: Any?] = ["comment": activeDateObject.comment, "confirmed": activeDateObject.confirmed, "date": activeDateString, "denied": activeDateObject.denied, "ignored": activeDateObject.ignored, "totalTime": activeDateObject.totalTime]
        
        let sessionData: [String: Any?] = [
            "id": sessionId,
            "startTime": timestamp,
            "isLeftHand": isLeftHand,
            "lastRefresh": timestamp,
            "deviceType": deviceType,
            SharedConstants.deviceId: deviceId,
            "date": activeDateDictionary
        ]
        
        do{
            try await db.collection(usersCollection).document(uID as? String ?? "").collection(activeDateString).document(sessionId).setData(sessionData as [String : Any], merge: true)
            print("Session successfully created")
        }catch{
            print("Session Creation Error :: \(error)")
        }
    }
    
    public func updateSessionTimeInFirestore(existingSession: Session?) async {
        guard let uID = USER_DEFAULTS.value(forKey: USERID) else{
            return
        }
        //let uID = USER_DEFAULTS.value(forKey: USERID) as! String
        let activeDateString = activeDateFormatter.string(from: existingSession?.date?.date ?? Date())
        let sessionId = existingSession?.id?.uuidString
        
        guard let sessionId = sessionId else{
            return
        }
        
        let sessionData: [String: Any?] = [
            "lastRefresh": existingSession?.lastRefresh,
            "endTime": existingSession?.endTime
        ]
        
        do{
            try await db.collection(usersCollection).document(uID as? String ?? "").collection(activeDateString).document(sessionId).setData(sessionData as [String : Any], merge: true)
            print("Session successfully updated")
        }catch{
            print("Session Updation Error :: \(error)")
        }
    }
    
    public func updateSessionCommentInFirestore(existingSession: Session?, comment: String) async {
        guard let uID = USER_DEFAULTS.value(forKey: USERID) else{
            return
        }
        //let uID = USER_DEFAULTS.value(forKey: USERID) as! String
        let activeDateString = activeDateFormatter.string(from: existingSession?.date?.date ?? Date())
        let sessionId = existingSession?.id?.uuidString
        
        guard let sessionId = sessionId else{
            return
        }
        
        let sessionData: [String: Any?] = [
            "comment": comment
        ]
        
        do{
            try await db.collection(usersCollection).document(uID as? String ?? "").collection(activeDateString).document(sessionId).setData(sessionData as [String : Any], merge: true)
            print("Comment successfully updated")
        }catch{
            print("Comment Updation Error :: \(error)")
        }
    }
    
    public func createSessionAlertInFirestore(alert: Alert) async {
        guard let uID = USER_DEFAULTS.value(forKey: USERID) else{
            return
        }
        //let uID = USER_DEFAULTS.value(forKey: USERID) as! String
        let activeDateString = activeDateFormatter.string(from: alert.session?.date?.date ?? Date())
        let sessionId = alert.session?.id?.uuidString
        let alertId = alert.id?.uuidString
        
        guard let sessionId = sessionId, let alertId = alertId else{
            return
        }
        
        var alertMotionArray: [[String: Any?]] = []
        if let alertMotionDataArray = Array(arrayLiteral: alert.alertMotionData) as? Array<AlertMotionData> {
            for alertData in alertMotionDataArray{
                let alertDataDict: [String: Any?] = ["type": alertData.type, "data": alertData.data]
                alertMotionArray.append(alertDataDict)
            }
        }
        
        let alertDataDictionary: [String: Any?] = [
            "id": alertId,
            "timestamp": alert.timestamp,
            "status": alert.status,
            "secondary": alert.secondary,
            "userAlerted": alert.userAlerted,
            "handStillNearPosition": alert.handStillNearPosition,
            "userAnswers": alert.userAnswers,
            "feeling": alert.feeling,
            "urge": alert.urge,
            "situation": alert.situation,
            "alertMotionData": alertMotionArray
        ]
        
        do{
            try await db.collection(usersCollection).document(uID as? String ?? "").collection(activeDateString).document(sessionId).collection(alertsCollection).document(alertId).setData(alertDataDictionary as [String : Any], merge: true)
            print("uID \(uID) >>> activeDateString \(activeDateString)")
            print("Alert successfully created")
        }catch{
            print("Alert Creation Error :: \(error)")
        }
    }
    
    public func updateAlertCommentInFirestore(alert: Alert, comment: String) async {
        guard let uID = USER_DEFAULTS.value(forKey: USERID) else{
            return
        }
        //let uID = USER_DEFAULTS.value(forKey: USERID) as! String
        let activeDateString = activeDateFormatter.string(from: alert.session?.date?.date ?? Date())
        let sessionId = alert.session?.id?.uuidString
        let alertId = alert.id?.uuidString
        
        guard let sessionId = sessionId, let alertId = alertId else{
            return
        }
        
        let alertDataDictionary: [String: Any?] = [
            "comment": comment
        ]
        
        do{
            try await db.collection(usersCollection).document(uID as? String ?? "").collection(activeDateString).document(sessionId).collection(alertsCollection).document(alertId).setData(alertDataDictionary as [String : Any], merge: true)
            print("Comment successfully updated")
        }catch{
            print("Comment Updation Error :: \(error)")
        }
    }
    
    public func updateSessionMotionDataForSessionInFirestore(sessionMotionData: SessionMotionData?) async {
        guard let uID = USER_DEFAULTS.value(forKey: USERID) else{
            return
        }
        //let uID = USER_DEFAULTS.value(forKey: USERID) as! String
        let activeDateString = activeDateFormatter.string(from: sessionMotionData?.session?.date?.date ?? Date())
        let sessionId = sessionMotionData?.session?.id?.uuidString
        
        guard let sessionId = sessionId else{
            return
        }
        
        let sessionMotionDataDictionary: [String: Any?] = [
            "data": sessionMotionData?.data,
            "timestamp": sessionMotionData?.timestamp
        ]
        
        let sessionData: [String: Any?] = [
            "sessionMotionData": sessionMotionDataDictionary,
        ]
        
        do{
            try await db.collection(usersCollection).document(uID as? String ?? "").collection(activeDateString).document(sessionId).setData(sessionData as [String : Any], merge: true)
            print("Session Motion Data successfully updated")
        }catch{
            print("Session Motion Data Updation Error :: \(error)")
        }
    }
    
    public func createSessionMLCallInFirestore(mlCall: MlCall) async {
        guard let uID = USER_DEFAULTS.value(forKey: USERID) else{
            return
        }
        //let uID = USER_DEFAULTS.value(forKey: USERID) as! String
        let activeDateString = activeDateFormatter.string(from: mlCall.session?.date?.date ?? Date())
        let sessionId = mlCall.session?.id?.uuidString
        
        guard let sessionId = sessionId else{
            return
        }
        
        let mlCallDataDictionary: [String: Any?] = [
            "features": mlCall.features,
            "outputString": mlCall.outputString,
            "modelType": mlCall.modelType,
            "timeDone": mlCall.timeDone,
            "beforeTime": mlCall.beforeTime,
            "featuresCalculatedTime": mlCall.featuresCalculatedTime
        ]
        
        do{
            try await db.collection(usersCollection).document(uID as? String ?? "").collection(activeDateString).document(sessionId).setData(["mlCalls": FieldValue.arrayUnion([mlCallDataDictionary as [String : Any]])], merge: true)
            print("MLCall successfully created")
        }catch{
            print("MLCall Creation Error :: \(error)")
        }
    }
    
    public func updateTotalTimeforSessionActiveDateInFirestore(activeDateObject: ActiveDate) async {
        guard let uID = USER_DEFAULTS.value(forKey: USERID) else{
            return
        }
        //let uID = USER_DEFAULTS.value(forKey: USERID) as! String
        let activeDateString = activeDateFormatter.string(from: activeDateObject.date ?? Date())
        
        let activeDateData: [String: Any?] = [
            activeDateString: activeDateObject.totalTime
        ]
        
        do{
            try await db.collection(usersCollection).document(uID as? String ?? "").collection(activeDateString).document(totalTimeCollection).setData(activeDateData as [String : Any], merge: true)
            print("Total time successfully updated")
        }catch{
            print("Total time Updation Error :: \(error)")
        }
    }
    
    public func updateSessionCountInFirestore(existingSession: Session?, sessionDenied: Bool? = nil, sessionIgnored: Bool? = nil, sessionConfirmed: Bool? = nil) async {
        guard let uID = USER_DEFAULTS.value(forKey: USERID) else{
            return
        }
        //let uID = USER_DEFAULTS.value(forKey: USERID) as! String
        let activeDateString = activeDateFormatter.string(from: existingSession?.date?.date ?? Date())
        let sessionId = existingSession?.id?.uuidString
        
        guard let sessionId = sessionId else{
            return
        }
        
        var sessionData: [String: Any?] = [:]
        if sessionDenied == true{
            sessionData = [
                "denied": existingSession?.denied
            ]
        }else if sessionIgnored == true{
            sessionData = [
                "ignored": existingSession?.ignored
            ]
        }else if sessionConfirmed == true{
            sessionData = [
                "confirmed": existingSession?.confirmed
            ]
        }else{
            return
        }
        
        do{
            try await db.collection(usersCollection).document(uID as? String ?? "").collection(activeDateString).document(sessionId).setData(sessionData as [String : Any], merge: true)
            print("Session Count successfully updated")
        }catch{
            print("Session Count Updation Error :: \(error)")
        }
    }
    
    public func createSessionSjEventInFirestore(sjEvent: SjEvent) async {
        guard let uID = USER_DEFAULTS.value(forKey: USERID) else{
            return
        }
        //let uID = USER_DEFAULTS.value(forKey: USERID) as! String
        let activeDateString = activeDateFormatter.string(from: sjEvent.session?.date?.date ?? Date())
        let sessionId = sjEvent.session?.id?.uuidString
        
        guard let sessionId = sessionId else{
            return
        }
        
        let sjEventDataDictionary: [String: Any?] = [
            "timestamp": sjEvent.timestamp,
            "type": sjEvent.type
        ]
        
        do{
            try await db.collection(usersCollection).document(uID as? String ?? "").collection(activeDateString).document(sessionId).setData(["events": FieldValue.arrayUnion([sjEventDataDictionary as [String : Any]])], merge: true)
            print("SjEvent successfully created")
        }catch{
            print("SjEvent Creation Error :: \(error)")
        }
    }
}
