//
//  FireStoreDatabase.swift
//  AImAware
//
//  Created by Suyog on 22/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class DatabaseManager {
    
    static let shared = DatabaseManager()
    private init(){}
    @ObservedObject var settings = PhoneSettings.shared
    public var database = Firestore.firestore()
    public var auth = Auth.auth()
    var totalAlertCount = 0
    var reminderArr = [[String:Any]]()
    @ObservedObject var statsViewModel = StatisticsViewModel.shared
    @StateObject var settingsViewModel = SettingsViewModel()
    
    //MARK: - Habbits
    func getAllHabits(completion: @escaping(_ habitData:[HabbitModel], _ status: Int) -> Void) {

        let query =  database.collection(FireStoreChatConstant.habbits)
        var habbitlist = [HabbitModel]()
        query.getDocuments(source: .server) { querySnapshot, error in
            if (querySnapshot?.documents.count ?? 0 > 0){
                if let snapShot = querySnapshot{
                    self.getMyHabbitsListData(querySnapshot: snapShot) { dict in
                        habbitlist = dict.map({ tempdict in
                            HabbitModel.init(tempdict)
                        })
                        if habbitlist.count == querySnapshot?.documents.count{
                            completion(habbitlist, 200)
                        }else{
                            completion([HabbitModel](), 400)
                        }
                        
                    }
                }
            }else{
                completion([HabbitModel](), 400)
            }
        }
    }
    
    private func getMyHabbitsListData(querySnapshot:QuerySnapshot, completion: @escaping(_ dict:[[String:Any]]) -> Void){
        var arrList = [[String:Any]]()
        var model = HabbitModel()
        for document in querySnapshot.documents {
            var tempDic = document.data()
            arrList.append(tempDic)
            
        }
        completion(arrList)
    }
    
    //MARK: - Steps Top Follow
    
    func getAllStepsToFollow(completion: @escaping(_ habitData:[StepsToFollowModel], _ status: Int) -> Void) {

        let query =  database.collection(FireStoreChatConstant.stepsToFollow)
        var stepsToFollowlist = [StepsToFollowModel]()
        query.getDocuments(source: .server) { querySnapshot, error in
            if (querySnapshot?.documents.count ?? 0 > 0){
                if let snapShot = querySnapshot{
                    self.getMyStepsToFollowListData(querySnapshot: snapShot) { dict in
                        stepsToFollowlist = dict.map({ tempdict in
                            StepsToFollowModel.init(tempdict)
                        })
                        if stepsToFollowlist.count == querySnapshot?.documents.count{
                            completion(stepsToFollowlist, 200)
                        }else{
                            completion([StepsToFollowModel](), 400)
                        }
                    }
                }
            }else{
                completion([StepsToFollowModel](), 400)
            }
        }
    }
    
    private func getMyStepsToFollowListData(querySnapshot:QuerySnapshot, completion: @escaping(_ dict:[[String:Any]]) -> Void){
        var arrList = [[String:Any]]()
        var model = StepsToFollowModel()
        for document in querySnapshot.documents {
            var tempDic = document.data()
            arrList.append(tempDic)
            
        }
        completion(arrList)
    }
    
    public func setUserDetails(userId: String, completion: @escaping(_ status: Int) -> Void) {
        var userDetails = [String:Any]()
        let createdAt: Timestamp?
        createdAt = Timestamp(date: Date())
        let model = SignUpCompleteViewModel.shared.fetchDataAsLocally()
        userDetails[FireStoreChatConstant.userFullName] = model.useFullName
        userDetails[FireStoreChatConstant.userEmail] = model.userEmail
        userDetails[FireStoreChatConstant.userAge] = model.userAge
        userDetails[FireStoreChatConstant.userHeight] = model.userHeight
        userDetails[FireStoreChatConstant.userGender] = model.userGender
        userDetails[FireStoreChatConstant.userCity] = model.userCity
        userDetails[FireStoreChatConstant.userHabit] = model.userHabit
        userDetails[FireStoreChatConstant.userAuthType] = model.userAuthType
        //userDetails[FireStoreChatConstant.userSubHabit] = model.userSubHabit
        print(userDetails)
        self.database.collection(FireStoreChatConstant.users).document(userId).setData(userDetails){ error in
            if error == nil{
                completion(200)
            }else{
                completion(400)
            }
        }
    }
    
    public func setUserReminder(userId: String, completion: @escaping(_ status: Int) -> Void) {
        var userDetails = [String:Any]()
        var userReminderDetails = [String:Any]()
        var reminderArr = [[String:Any]]()
        let model = SignUpCompleteViewModel.shared.fetchDataAsLocally()
        for reminder in model.userWeekendReminder ?? [] {
            userDetails[FireStoreChatConstant.userReminder] = model.userReminder
            userDetails[FireStoreChatConstant.userReminderStatus] = true
            userDetails[FireStoreChatConstant.userWeekendReminder] = reminder
            reminderArr.append(userDetails)
        }
        userReminderDetails[FireStoreChatConstant.userReminderArr] = reminderArr
        self.database.collection(FireStoreChatConstant.users).document(userId).updateData(userReminderDetails) { error in
            if error == nil{
                self.addReminder(reminderArr: reminderArr)
                completion(200)
            }else{
                completion(400)
            }
        }
    }
    
    func addReminder(reminderArr: [[String:Any]]){
        settingsViewModel.setNotificationOnTimers(userDetail: reminderArr) { triggerArr,triggerDateArr  in
            CustomNotification.shared.callNotification(triggerArr: triggerArr)
            self.settings.updateReminderNotificationSetting(triggerDateArr)
            self.settings.deleteReminderNotification = [:]
        }
    }
    
    //MARK: - Get User Detail
    func getUserDetail(completion: @escaping(_ userData:[String:Any], _ status: Int) ->Void) {
        let userId = SignUpCompleteViewModel.shared.getCurrentUserId()
        if userId != ""{
            let query =  database.collection(FireStoreChatConstant.users).document(userId ?? "")
            query.getDocument(source: .server, completion:{ (document, error) in
                if let document = document, document.exists {
                    var tempDic = document.data()
                    completion(tempDic ?? [:], 200)
                } else {
                    completion([:], 500)
                }
            })
        }
    }
    
    
    //MARK: - Update User Detail
    public func getUserReminder(userId: String, model: SignUpCompleteFlowModel, completion: @escaping(_ status: Int) -> Void) {
        
        self.getUserDetail { userDetail, status in
            if status == 200{
                if let reminderData = userDetail[FireStoreChatConstant.userReminderArr] {
                    var arrDict : [[String:Any]] = reminderData as? [[String:Any]] ?? [[:]]
                    self.updateUserReminder(userId: userId, arrDict: arrDict, model: model) { status in
                        completion(status)
                    }
                }
            }else{
                completion(status)
            }
        }
    }
    
    func updateUserReminder(userId: String, arrDict: [[String: Any]], model: SignUpCompleteFlowModel, completion: @escaping(_ status: Int) -> Void){
        var newArrDict = arrDict
        var userDetails = [String:Any]()
        var userReminderDetails = [String:Any]()
        for reminder in model.userWeekendReminder ?? [] {
            userDetails[FireStoreChatConstant.userReminder] = model.userReminder
            userDetails[FireStoreChatConstant.userReminderStatus] = true
            userDetails[FireStoreChatConstant.userWeekendReminder] = reminder
            newArrDict.append(userDetails)
        }
        userReminderDetails[FireStoreChatConstant.userReminderArr] = newArrDict
        self.database.collection(FireStoreChatConstant.users).document(userId).updateData(userReminderDetails) { error in
            if error == nil{
                completion(200)
            }else{
                completion(400)
            }
        }
    }
    
    func updateReminderOnSwitchChange(userReminderArr: [[String: Any]], completion: @escaping(_ status: Int) -> Void){
        let userId = SignUpCompleteViewModel.shared.getCurrentUserId()
        var userDetails = [String:Any]()
        userDetails[FireStoreChatConstant.userReminderArr] = userReminderArr
        self.database.collection(FireStoreChatConstant.users).document(userId ?? "").updateData(userDetails) { error in
            if error == nil{
                completion(200)
            }else{
                completion(400)
            }
        }
    }
    
    //MARK: - Delete Reminder
    func deleteReminder(userReminderArr: [String: Any], completion: @escaping(_ status: Int) -> Void){
        print(userReminderArr)
        let userId = SignUpCompleteViewModel.shared.getCurrentUserId()
        self.database.collection(FireStoreChatConstant.users).document(userId ?? "").updateData([FireStoreChatConstant.userReminderArr: FieldValue.arrayRemove([userReminderArr])]) { error in
            if error == nil{
                let reminderTime = userReminderArr[FireStoreChatConstant.userReminder] as? String ?? ""
                let weekendReminder = userReminderArr[FireStoreChatConstant.userWeekendReminder] as? String ?? ""
                print("reminder \(reminderTime) weekend \(weekendReminder)")
                CustomNotification.shared.cancelNotification(time: reminderTime, weekend: weekendReminder)
                /*settingsViewModel.getTimeReminder(timeReminderStr: reminderTime) { hour, minute in
                    settingsViewModel.getWeekendReminder(weekendReminderStr: weekendReminder) { weekDay in
                        var userDetail = [String: Any]()
                        userDetail["Hour"] = hour
                        userDetail["Minute"] = minute
                        userDetail["WeekDay"] = weekDay
                        settings.deleteReminderNotification = userDetail
                    }
                }*/
                completion(200)
            }else{
                completion(400)
            }
        }
    }
    
    //MARK: - Update Delay
    func updateDelay(delayData: [String: Any], completion: @escaping(_ status: Int) -> Void){
        if let userId = SignUpCompleteViewModel.shared.getCurrentUserId(){
            if userId != ""{
                self.database.collection(FireStoreChatConstant.users).document(userId).updateData(delayData) { error in
                    if error == nil{
                        completion(200)
                    }else{
                        completion(400)
                    }
                }
            }
        }
    }
    
    //MARK: - Delete Account
    func deleteAccount(completion: @escaping(_ status: Int) -> Void){
        let userId = SignUpCompleteViewModel.shared.getCurrentUserId()
        self.database.collection(FireStoreChatConstant.users).document(userId ?? "").delete { error in
            if error == nil{
                completion(200)
            }else{
                completion(400)
            }
        }
    }
  
    //MARK: - Statistics
    
    func getCurrentWeekDates(completion: @escaping( _ graphArr: [NSDictionary]) -> Void) {
        
        let dateInWeek = Date()

        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: dateInWeek) - 1
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: dateInWeek)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: dateInWeek) }

        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
                
        print(days)
        self.totalAlertCount = 0
        self.statsViewModel.getAllAlertDictArr = [NSDictionary]()
        
        for date in days {
            print(formatter.string(from: date))
            getAllDocumentsFromDate(weekDate: formatter.string(from: date)) { getAllAlertDict in
                if self.totalAlertCount == self.statsViewModel.getAllAlertDictArr.count {
                    completion(getAllAlertDict)
                }
            }
        }
    }
    
    func getCurrentMonthDates(completion: @escaping( _ graphArr: [NSDictionary], _ monthArr: [String]) -> Void) {
        
        var today = Date()
        var getDateArray = [String]()
        var dateArray = [String]()
        
        
        let calendar = Calendar.current
        let currentDate = Date()
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        //var dates: [Date] = []
        
        for day in 1...30 {
            var components = DateComponents()
            components.year = currentYear
            components.month = currentMonth
            components.day = day
            if let date = calendar.date(from: components) {
                let formaterr = DateFormatter()
                formaterr.dateFormat = "dd-MM-yyyy"
                var stringDate : String = formaterr.string(from: date)
                getDateArray.append(stringDate)
                
                let newformaterr = DateFormatter()
                newformaterr.dateFormat = "dd MMM"
                let newStringDate : String = newformaterr.string(from: date)
                dateArray.append(newStringDate)
            }
        }
        
        self.totalAlertCount = 0
        self.statsViewModel.getAllAlertDictArr = [NSDictionary]()
        print(getDateArray)
        for date in getDateArray {
            getAllDocumentsFromDate(weekDate: date) { getAllAlertDict in
                if self.totalAlertCount == self.statsViewModel.getAllAlertDictArr.count {
                    print(getAllAlertDict)
                    completion(getAllAlertDict, dateArray)
                }
            }
        }
    }
    
    
    func getAllDocumentsFromDate(weekDate: String, completion: @escaping( _ graphArr: [NSDictionary]) -> Void){
        let userId = SignUpCompleteViewModel.shared.getCurrentUserId()
        if userId != ""{
            let query =  database.collection(FireStoreChatConstant.users).document(userId ?? "").collection(weekDate)
            query.getDocuments(source: .server) { (snapShots, error) in
                if error == nil{
                    print("weekDate \(weekDate)")
                    print("snapShots?.documents alert.count \(snapShots?.documents.count)")
                    if (snapShots?.documents.count ?? 0 > 0) {

                        if let snapshot = snapShots {
                            self.getAlertsCountFromDocuments(weekDate: weekDate, querySnapshots: snapshot) { getAllAlertDict in
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
    
    func getAlertsCountFromDocuments(weekDate: String, querySnapshots:QuerySnapshot, completion: @escaping( _ graphArr: [NSDictionary]) -> Void){
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
                                self.getAllTypesOfStatsCount( weekDate: weekDate, alertQuerySnapshotsId: querySnapshot.documentID, statusQuerySnapshots: alertSnapShot) { getAllAlertDict in
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
    
    func getAllTypesOfStatsCount(weekDate: String, alertQuerySnapshotsId:String, statusQuerySnapshots:QuerySnapshot, completion: @escaping( _ getAllAlertDict: [NSDictionary]) -> Void){
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
                        self.statsViewModel.getAllAlertDictArr.append(tempDic as? NSDictionary ?? [:])
                        if count == statusQuerySnapshots.documents.count {
                            group.leave()
                        }
                        
                    }
                    
                })
                
            }
            group.notify(queue: .main) {
                //if self.statsViewModel.getAllAlertDictArr.count == self.totalCountAlert {
                    completion(self.statsViewModel.getAllAlertDictArr)
                //}
            }
           // completion(StatisticsViewModel.shared.getAllAlertDictArr)
            
        }else{
            //completion(StatisticsViewModel.shared.getAllAlertDictArr)
            print("No alerts found for this particular weekday that means its going to 0")
        }
    }
}


