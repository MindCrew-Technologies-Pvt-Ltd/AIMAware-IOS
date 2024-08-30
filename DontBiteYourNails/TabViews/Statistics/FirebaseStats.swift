//
//  FirebaseStats.swift
//  AImAware
//
//  Created by Suyog on 20/06/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class StatsDatabaseManager {
    
    static let shared = StatsDatabaseManager()
    private init(){}
    @ObservedObject var settings = PhoneSettings.shared
    public var database = Firestore.firestore()
    public var auth = Auth.auth()
    var totalAlertCount = 0
    var reminderArr = [[String:Any]]()
    @ObservedObject var statsViewModel = StatisticsViewModel.shared
    @StateObject var settingsViewModel = SettingsViewModel()
    
    func getCurrentDate(completion: @escaping( _ graphArr: [NSDictionary]) -> Void) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        
        self.totalAlertCount = 0
        self.statsViewModel.getTodayAllAlertDictArr = [NSDictionary]()
        
        getTodayAllDocumentsFromDate(weekDate: formatter.string(from: date)) { getAllAlertDict in
            if self.totalAlertCount == self.statsViewModel.getTodayAllAlertDictArr.count {
                print(getAllAlertDict)
                completion(getAllAlertDict)
            }
        }
    }
    
    func getTodayAllDocumentsFromDate(weekDate: String, completion: @escaping( _ graphArr: [NSDictionary]) -> Void){
        let userId = SignUpCompleteViewModel.shared.getCurrentUserId()
        if userId != ""{
            let query =  database.collection(FireStoreChatConstant.users).document(userId ?? "").collection(weekDate)
            query.getDocuments(source: .server) { (snapShots, error) in
                if error == nil{
                    print("weekDate \(weekDate)")
                    print("snapShots?.documents alert.count \(snapShots?.documents.count)")
                    if (snapShots?.documents.count ?? 0 > 0) {

                        if let snapshot = snapShots {
                            self.getTodayAlertsCountFromDocuments(weekDate: weekDate, querySnapshots: snapshot) { getAllAlertDict in
                                completion(getAllAlertDict)
                            }
                        }else{
                            //completion(StatisticsViewModel.shared.getAllAlertDictArr)
                        }
                    }else{
                        completion([])
                    }
                }else{
                    completion([])
                }
                
            }
        }else{
            //completion(StatisticsViewModel.shared.getAllAlertDictArr)
        }
    }
    
    func getTodayAlertsCountFromDocuments(weekDate: String, querySnapshots:QuerySnapshot, completion: @escaping( _ graphArr: [NSDictionary]) -> Void){
        let userId = SignUpCompleteViewModel.shared.getCurrentUserId() ?? ""
        if querySnapshots.count > 0 {
            var alertList = [NSDictionary]()
            var count = 0
            let group = DispatchGroup()
            group.enter()
            for querySnapshot in querySnapshots.documents {
            
                print(querySnapshot.documentID)
                let query = self.database.collection(FireStoreChatConstant.users).document(userId).collection(weekDate).document(querySnapshot.documentID).collection(FireStoreChatConstant.statsFirebaseKey)
                query.getDocuments { alertSnapShots, error in
                    count = count + 1
                    if error == nil{
                        if alertSnapShots?.count ?? 0 > 0 {
                            if let alertSnapShot = alertSnapShots {
                                self.totalAlertCount = self.totalAlertCount + (alertSnapShots?.count ?? 0)
                                self.getTodayAllTypesOfStatsCount( weekDate: weekDate, alertQuerySnapshotsId: querySnapshot.documentID, statusQuerySnapshots: alertSnapShot) { getAllAlertDict in
                                    print(count)
                                    print(querySnapshots.documents.count)
                                    if count == querySnapshots.documents.count {
                                        alertList = getAllAlertDict
                                        print("group \(group)")
                                        completion(alertList)
                                        //do { group.leave() }
                                    }
                                }
                            }
                            
                        }else{
                            if count == querySnapshots.documents.count {
                                alertList = []
                                group.leave()
                            }
                            print("No alerts found for this particular weekday that means its going to 0")
                        }
                    }
                }
            }
            group.notify(queue: .main) {
                completion(alertList)
            }
            
            //completion(StatisticsViewModel.shared.getAllAlertDictArr)
            
        }else{
            //completion(StatisticsViewModel.shared.getAllAlertDictArr)
            print("No alerts found for this particular weekday that means its going to 0")
        }
    }
    
    func getTodayAllTypesOfStatsCount(weekDate: String, alertQuerySnapshotsId:String, statusQuerySnapshots:QuerySnapshot, completion: @escaping( _ getAllAlertDict: [NSDictionary]) -> Void){
        let userId = SignUpCompleteViewModel.shared.getCurrentUserId() ?? ""
        if statusQuerySnapshots.count > 0 {
            var count = 0
            let group = DispatchGroup()
            group.enter()
            for querySnapshot in statusQuerySnapshots.documents {
                let query = self.database.collection(FireStoreChatConstant.users).document(userId).collection(weekDate).document(alertQuerySnapshotsId).collection(FireStoreChatConstant.statsFirebaseKey).document(querySnapshot.documentID)
                
                query.getDocument(source: .server, completion:{ (document, error) in
                    if let document = document, document.exists {
                        count = count + 1
                        let tempDic = document.data()
                        self.statsViewModel.getTodayAllAlertDictArr.append(tempDic as? NSDictionary ?? [:])
                        if count == statusQuerySnapshots.documents.count {
                            group.leave()
                        }
                        
                    }
                    
                })
                
            }
            group.notify(queue: .main) {
                //if self.statsViewModel.getAllAlertDictArr.count == self.totalCountAlert {
                    completion(self.statsViewModel.getTodayAllAlertDictArr)
                //}
            }
           // completion(StatisticsViewModel.shared.getAllAlertDictArr)
            
        }else{
            //completion(StatisticsViewModel.shared.getAllAlertDictArr)
            print("No alerts found for this particular weekday that means its going to 0")
        }
    }
    
}