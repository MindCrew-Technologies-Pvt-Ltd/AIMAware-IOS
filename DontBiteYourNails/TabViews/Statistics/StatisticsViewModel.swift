//
//  StatisticsViewModel.swift
//  AImAware
//
//  Created by Suyog on 29/05/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import Firebase
enum AllStatisticsStatusType : String {
    case confirmed
    case ignored
    case Confirmed
    case Ignored
    
    case workStudy = "Work/study"
    case Idle
    case socialMedia = "On social media"
    case Other

}

enum FeelingStatisticsStatusType : String {
    
    case Anxious
    case Stressed
    case Frustrated
    case Bored
    case Sad
    case Tired
    case Other

}



enum AllWeekDays : String {
    case Mon
    case Tue
    case Wed
    case Thu
    case Fri
    case Sat
    case Sun
    
}

enum DaysType : String {
    case Today
    case Week
    case Month
    
}

enum SituationType : String {
    case confirmedIgnore
    case feeling
    case workSchedule
    case averageIntensity
}

class StatisticsViewModel: ObservableObject {
    static let shared = StatisticsViewModel()
    var weekDateStepArr = NSMutableArray()
    var getAllAlertDictArr = [NSDictionary]()
    var getTodayAllAlertDictArr = [NSDictionary]()
    var getMonthAllAlertDictArr = [NSDictionary]()
    var saveAllTypeStatusArr = [statsAllTypeModel]()
    var confirmedIgnoredCount = 0
    var anxiousCount = 0
    var stressedCount = 0
    var boredCount = 0
    var sadCount = 0
    var tiredCount = 0
    
    
    func getAllStatusCount(getAllAlertArr: [NSDictionary], monthArr: [statsMonthModel], weekDateType: String, situationType: String, completion: @escaping(_ confirmedIgnoreCountArr: NSMutableArray) -> Void){
        
        saveAllTypeStatusArr = [statsAllTypeModel]()
        for dict in getAllAlertArr {
            let tsdate = dict.value(forKey: "timestamp") as! Timestamp
            let aDate = tsdate.dateValue()
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"
            let day = formatter.string(from: aDate)
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd MMM"
            let dateMonth = dateformatter.string(from: aDate)
            
            
            let model : statsAllTypeModel = statsAllTypeModel(status: dict.value(forKey: "status") as? String ?? "", feeling: dict.value(forKey: "feeling") as? String ?? "", situation: dict.value(forKey: "situation") as? String ?? "", urgeIntensity: dict.value(forKey: "urge") as? Int ?? 0, day: day, dateMonth: dateMonth)
            saveAllTypeStatusArr.append(model)
            
        }
        
        switch situationType {
        case SituationType.confirmedIgnore.rawValue:
            getAllStatusCountInArr(monthArr: monthArr, situationType: situationType, weekDateType: weekDateType) { statusArr in
                completion(statusArr)
            }
        case SituationType.feeling.rawValue:
            saveDataForConfirmedIgnored(modelArr: saveAllTypeStatusArr, situationType: situationType, monthArr: monthArr, weekDateType: weekDateType) { statusArr in
                completion(statusArr)
            }
        case SituationType.workSchedule.rawValue:
            saveDataForConfirmedIgnored(modelArr: saveAllTypeStatusArr, situationType: situationType, monthArr: monthArr, weekDateType: weekDateType) { statusArr in
                completion(statusArr)
            }
        case SituationType.averageIntensity.rawValue:
            saveDataForConfirmedIgnored(modelArr: saveAllTypeStatusArr, situationType: situationType, monthArr: monthArr, weekDateType: weekDateType) { statusArr in
                completion(statusArr)
            }
        default:
            break
        }
        
        
    }
    
    func getAllStatusCountInArr(monthArr: [statsMonthModel], situationType: String, weekDateType: String, completion: @escaping(_ statusArr: NSMutableArray) -> Void){
        
        let confirmedIgnoredArr = saveAllTypeStatusArr.filter({$0.status == AllStatisticsStatusType.confirmed.rawValue || $0.status == AllStatisticsStatusType.ignored.rawValue || $0.status == AllStatisticsStatusType.Confirmed.rawValue || $0.status == AllStatisticsStatusType.Ignored.rawValue})
        
        saveDataForConfirmedIgnored(modelArr: confirmedIgnoredArr, situationType: situationType, monthArr: monthArr, weekDateType: weekDateType) { statusArr in
            completion(statusArr)
        }
    }
    
    func saveDataForConfirmedIgnored(modelArr: [statsAllTypeModel], situationType: String , monthArr: [statsMonthModel], weekDateType: String, completion: @escaping(_ statusArr: NSMutableArray) -> Void){
        
        let statusArr = NSMutableArray()
        if weekDateType == "Today"{
            
            if situationType == SituationType.workSchedule.rawValue{
                statusArr.insert(modelArr.filter({$0.situation == AllStatisticsStatusType.workStudy.rawValue}).count, at: 0)
                statusArr.insert(modelArr.filter({$0.situation == AllStatisticsStatusType.Idle.rawValue}).count, at: 1)
                statusArr.insert(modelArr.filter({$0.situation == AllStatisticsStatusType.socialMedia.rawValue}).count, at: 2)
                statusArr.insert(modelArr.filter({$0.situation == AllStatisticsStatusType.Other.rawValue}).count, at: 3)
                completion(statusArr)
                
            }else {
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 1}).count, at: 0)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 2}).count, at: 1)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 3}).count, at: 2)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 4}).count, at: 3)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 5}).count, at: 4)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 6}).count, at: 5)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 7}).count, at: 6)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 8}).count, at: 7)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 9}).count, at: 8)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 10}).count, at: 9)
                completion(statusArr)
            }
            
        }else if weekDateType == "Week"{
            if situationType == SituationType.confirmedIgnore.rawValue{
                statusArr.insert(modelArr.filter({$0.day == AllWeekDays.Mon.rawValue}).count, at: 0)
                statusArr.insert(modelArr.filter({$0.day == AllWeekDays.Tue.rawValue}).count, at: 1)
                statusArr.insert(modelArr.filter({$0.day == AllWeekDays.Wed.rawValue}).count, at: 2)
                statusArr.insert(modelArr.filter({$0.day == AllWeekDays.Thu.rawValue}).count, at: 3)
                statusArr.insert(modelArr.filter({$0.day == AllWeekDays.Fri.rawValue}).count, at: 4)
                statusArr.insert(modelArr.filter({$0.day == AllWeekDays.Sat.rawValue}).count, at: 5)
                statusArr.insert(modelArr.filter({$0.day == AllWeekDays.Sun.rawValue}).count, at: 6)
                completion(statusArr)
                
            }else if situationType == SituationType.feeling.rawValue{
                statusArr.insert(modelArr.filter({$0.feeling == FeelingStatisticsStatusType.Anxious.rawValue}).count, at: 0)
                statusArr.insert(modelArr.filter({$0.feeling == FeelingStatisticsStatusType.Stressed.rawValue}).count, at: 1)
                statusArr.insert(modelArr.filter({$0.feeling == FeelingStatisticsStatusType.Frustrated.rawValue}).count, at: 2)//frustrated
                statusArr.insert(modelArr.filter({$0.feeling == FeelingStatisticsStatusType.Bored.rawValue}).count, at: 3)
                statusArr.insert(modelArr.filter({$0.feeling == FeelingStatisticsStatusType.Sad.rawValue}).count, at: 4)
                statusArr.insert(modelArr.filter({$0.feeling == FeelingStatisticsStatusType.Tired.rawValue}).count, at: 5)
                statusArr.insert(modelArr.filter({$0.feeling == FeelingStatisticsStatusType.Other.rawValue}).count, at: 6)
                print(statusArr)
                completion(statusArr)
                
            }else if situationType == SituationType.workSchedule.rawValue{
                statusArr.insert(modelArr.filter({$0.situation == AllStatisticsStatusType.workStudy.rawValue}).count, at: 0)
                statusArr.insert(modelArr.filter({$0.situation == AllStatisticsStatusType.Idle.rawValue}).count, at: 1)
                statusArr.insert(modelArr.filter({$0.situation == AllStatisticsStatusType.socialMedia.rawValue}).count, at: 2)
                statusArr.insert(modelArr.filter({$0.situation == AllStatisticsStatusType.Other.rawValue}).count, at: 3)
                completion(statusArr)
                
            }else {
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 1}).count, at: 0)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 2}).count, at: 1)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 3}).count, at: 2)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 4}).count, at: 3)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 5}).count, at: 4)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 6}).count, at: 5)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 7}).count, at: 6)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 8}).count, at: 7)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 9}).count, at: 8)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 10}).count, at: 9)
                completion(statusArr)
            }
                        
        }else{
            
            if situationType == SituationType.confirmedIgnore.rawValue{
                print(monthArr)
                for i in 0 ..< monthArr.count {
                    let date = monthArr[i]
                    
                    statusArr.insert(modelArr.filter({$0.dateMonth == date.monthStr}).count, at: i)
                    
                }
                completion(statusArr)
                
            }else if situationType == SituationType.feeling.rawValue{
                statusArr.insert(modelArr.filter({$0.feeling == FeelingStatisticsStatusType.Anxious.rawValue}).count, at: 0)
                statusArr.insert(modelArr.filter({$0.feeling == FeelingStatisticsStatusType.Stressed.rawValue}).count, at: 1)
                statusArr.insert(modelArr.filter({$0.feeling == FeelingStatisticsStatusType.Frustrated.rawValue}).count, at: 2)
                statusArr.insert(modelArr.filter({$0.feeling == FeelingStatisticsStatusType.Bored.rawValue}).count, at: 3)
                statusArr.insert(modelArr.filter({$0.feeling == FeelingStatisticsStatusType.Sad.rawValue}).count, at: 4)
                statusArr.insert(modelArr.filter({$0.feeling == FeelingStatisticsStatusType.Tired.rawValue}).count, at: 5)
                statusArr.insert(modelArr.filter({$0.feeling == FeelingStatisticsStatusType.Other.rawValue}).count, at: 6)
                completion(statusArr)
                
            }else if situationType == SituationType.workSchedule.rawValue{
                statusArr.insert(modelArr.filter({$0.situation == AllStatisticsStatusType.workStudy.rawValue}).count, at: 0)
                statusArr.insert(modelArr.filter({$0.situation == AllStatisticsStatusType.Idle.rawValue}).count, at: 1)
                statusArr.insert(modelArr.filter({$0.situation == AllStatisticsStatusType.socialMedia.rawValue}).count, at: 2)
                statusArr.insert(modelArr.filter({$0.situation == AllStatisticsStatusType.Other.rawValue}).count, at: 3)
                completion(statusArr)
                
            }else {
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 1}).count, at: 0)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 2}).count, at: 1)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 3}).count, at: 2)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 4}).count, at: 3)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 5}).count, at: 4)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 6}).count, at: 5)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 7}).count, at: 6)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 8}).count, at: 7)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 9}).count, at: 8)
                statusArr.insert(modelArr.filter({$0.urgeIntensity == 10}).count, at: 9)
                completion(statusArr)
            }
        }
    }
}

//MARK: - Confirmed Ignore
extension StatisticsView {
    func getWeekArr(){
        confirmedIgnoreWeekArr = NSMutableArray()
        
        statsViewModel.getAllAlertDictArr = [NSDictionary]()
        
        confirmedIgnoreModelWeekArr = [statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1)]
        
    }
    
    func getMonthArr(){
        confirmedIgnoreMonthArr = NSMutableArray()
        statsViewModel.getAllAlertDictArr = [NSDictionary]()
        
        confirmedIgnoreModelMonthArr = [statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1)]
    }
    
    
}


//MARK: - Feeling
extension StatisticsView {
    func getWeekFeelingArr(){
        feelingWeekArr = NSMutableArray()
        
        feelingUserStatusModelWeekArr = [statsUserStatusModel(userStatusCount: 0, userStatusName:                                   "Anxious"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "Stressed"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "Frustrated"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "Bored"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "Sad"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "Tired"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "Other")]
                
        /*feelingModelWeekArr = [statsConfirmedIgnoredModel(confirmIgnoreCount: 0),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 0),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 0),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 0),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 0)]*/
        
    }
    
    func getMonthFeelingArr(){
        feelingMonthArr = NSMutableArray()
        statsViewModel.getAllAlertDictArr = [NSDictionary]()
        
        feelingUserStatusModelMonthArr = [statsUserStatusModel(userStatusCount: 0, userStatusName:                                   "Anxious"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "Stressed"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "Frustrated"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "Bored"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "Sad"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "Tired"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "Other")]
        
        /*feelingModelMonthArr = [statsConfirmedIgnoredModel(confirmIgnoreCount: 0),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 0),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 0),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 0),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 0)]*/
    }
    
}


//MARK: - Work Schedule
extension StatisticsView {
    func getTodayWorkScheduleArr(){
        workScheduleTodayArr = NSMutableArray()
        
        workScheduleUserStatusModelTodayArr = [statsUserStatusModel(userStatusCount: 0,                                         userStatusName:"Work/Study"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "Idle"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "On Social Media"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "Other")]
                
        /*workScheduleModelTodayArr = [statsConfirmedIgnoredModel(confirmIgnoreCount: 0),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 0),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 0),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 0)]*/
        
    }
    
    func getWeekWorkScheduleArr(){
        workScheduleWeekArr = NSMutableArray()
        
        workScheduleUserStatusModelWeekArr = [statsUserStatusModel(userStatusCount: 0,                                          userStatusName: "Work/Study"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "Idle"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "On Social Media"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "Other")]
                
        /*workScheduleModelWeekArr = [statsConfirmedIgnoredModel(confirmIgnoreCount: 0),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 0),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 0),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 0)]*/
        
    }
    
    func getMonthWorkScheduleArr(){
        workScheduleMonthArr = NSMutableArray()
        statsViewModel.getAllAlertDictArr = [NSDictionary]()
        
        workScheduleUserStatusModelMonthArr = [statsUserStatusModel(userStatusCount: 0,                                         userStatusName: "Work/Study"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "Idle"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "On Social Media"),
                                         statsUserStatusModel(userStatusCount: 0, userStatusName: "Other")]
        
        /*workScheduleModelMonthArr = [statsConfirmedIgnoredModel(confirmIgnoreCount: 0),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 0),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 0),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 0)]*/
    }
}

//MARK: - Average Intensity
extension StatisticsView {
    func getTodayAverageIntensityArr(){
        averageIntensityTodayArr = NSMutableArray()
                
        averageIntensityModelTodayArr = [statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                          statsConfirmedIgnoredModel(confirmIgnoreCount: 1)]
        
    }
    
    func getWeekAverageIntensityArr(){
        averageIntensityWeekArr = NSMutableArray()
                
        averageIntensityModelWeekArr = [statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                        statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                        statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                        statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                        statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                        statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                        statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                        statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                        statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                        statsConfirmedIgnoredModel(confirmIgnoreCount: 1)]
        
    }
    
    func getMonthAverageIntensityArr(){
        averageIntensityMonthArr = NSMutableArray()
        statsViewModel.getAllAlertDictArr = [NSDictionary]()
        
        averageIntensityModelMonthArr = [statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                         statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                         statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                         statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                         statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                         statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                         statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                         statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                         statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                         statsConfirmedIgnoredModel(confirmIgnoreCount: 1)]
    }
}
