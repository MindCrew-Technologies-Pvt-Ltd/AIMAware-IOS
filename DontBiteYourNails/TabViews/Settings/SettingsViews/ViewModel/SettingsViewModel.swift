//
//  SettingsViewModel.swift
//  AImAware
//
//  Created by Maulik Bhuptani on 26/02/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import FirebaseAuth
import UserNotifications

enum AppWeekends : String {
    case Sunday
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday

}

class SettingsViewModel: ObservableObject {
    var triggerArr = [NotificationModel]()
    var triggerDateArr = [[String: Any]]()
    func logoutUser(completion: @escaping (Bool, String?) -> ()){
        do {
            try Auth.auth().signOut()
            completion(true, nil)
        } catch let signOutError as NSError {
            completion(false, signOutError.localizedDescription)
        }
    }
    
    func deleteUserAccount(completion: @escaping (Bool, String?) -> ()){
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    completion(false, error.localizedDescription)
                } else {
                    DatabaseManager.shared.deleteAccount { status in
                        if status == 200{
                            completion(true, nil)
                        }else{
                            completion(false, error?.localizedDescription)
                        }
                    }
                }
            }
        }
        else{
            completion(true, nil)
        }
    }
    
    
    //MARK: - Notification Methods
    func setNotificationOnTimers(userDetail: [[String: Any]], completion: @escaping(_ triggerArr: [NotificationModel], _ triggerDateArr: [[String: Any]]) -> ()){
        triggerArr = [NotificationModel]()
        triggerDateArr = [[String: Any]]()
        for i in 0 ..< userDetail.count {
            let dict = userDetail[i]
            if dict[FireStoreChatConstant.userReminderStatus] as? Bool ?? false == true{
                getWeekendReminder(weekendReminderStr: dict[FireStoreChatConstant.userWeekendReminder] as? String ?? "") { weekDay in
                    self.getTimeReminder(timeReminderStr: dict[FireStoreChatConstant.userReminder] as? TimeInterval ?? 946715700) { hour,minute  in
                        let model : NotificationModel = NotificationModel(weekend: dict[FireStoreChatConstant.userWeekendReminder] as? String ?? "", time: dict[FireStoreChatConstant.userReminder] as? String ?? "", trigerTime: UNCalendarNotificationTrigger(dateMatching: DateComponents.triggerFor(hour: hour, minute: minute, weekday: weekDay), repeats: true))
                        self.triggerArr.append(model)
                        
                        var userDetails = [String:Any]()
                        userDetails["Hour"] = hour
                        userDetails["Minute"] = minute
                        userDetails["WeekDay"] = weekDay
                        self.triggerDateArr.append(userDetails)
                        
                    }
                }
            }
        }
        completion(triggerArr, triggerDateArr)
    }
    
    func getWeekendReminder(weekendReminderStr: String, completion: @escaping(_ weekDay: Int) -> ()){
        let split = weekendReminderStr.split(separator: " ")
        let weekendStr = String(split.suffix(1).joined(separator: [" "]))
        getIntValueAccToWeekend(weekendValue: weekendStr) { weekDay in
            completion(weekDay)
        }
        
    }
    
    func getIntValueAccToWeekend(weekendValue: String, completion: @escaping(_ weekDay: Int) -> ()) {
        switch weekendValue {
        case AppWeekends.Sunday.rawValue:
            completion(1)
        case AppWeekends.Monday.rawValue:
            completion(2)
        case AppWeekends.Tuesday.rawValue:
            completion(3)
        case AppWeekends.Wednesday.rawValue:
            completion(4)
        case AppWeekends.Thursday.rawValue:
            completion(5)
        case AppWeekends.Friday.rawValue:
            completion(6)
        case AppWeekends.Saturday.rawValue:
            completion(7)
        default:
            completion(0)
        }
    }
    
    func getTimeReminder(timeReminderStr: TimeInterval, completion: @escaping(_ hour: Int, _ minute: Int) -> ()) {
        
        let time = timeReminderStr.convertTimeIntervalToString()
        
        let split = time.split(separator: ":")
        let colonStr = split[1]
        let amPm = colonStr.suffix(2)
        let minStr = colonStr.prefix(2)
        
        if amPm == "PM"{
            completion(getIntValueAccToTime(timeValue: String(split[0])), Int(minStr) ?? 0)
        }else{
            completion(Int(split[0]) ?? 0, Int(minStr) ?? 0)
        }
    }
    
    func getIntValueAccToTime(timeValue: String) -> Int {
        switch timeValue {
        case "1":
            return 13
        case "2":
            return 14
        case "3":
            return 15
        case "4":
            return 16
        case "5":
            return 17
        case "6":
            return 18
        case "7":
            return 19
        case "8":
            return 20
        case "9":
            return 21
        case "10":
            return 22
        case "11":
            return 23
        case "12":
            return 12
        default:
            return 0
        }
    }
}





