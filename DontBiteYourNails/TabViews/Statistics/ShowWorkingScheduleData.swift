//
//  ShowWorkingScheduleData.swift
//  AImAware
//
//  Created by Suyog on 11/06/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI
extension StatisticsView {
    //MARK: - For Showing What Are You Doing Data
    func workingSchedule() -> some View{
        VStack() {
            HStack{
                Text("What are you doing").font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                    .foregroundColor(Color("MainTextColor"))
                Spacer(minLength: 2)
                
                Button {
                    selectedWorkSchedule = "Today"
                    showWorkScheduleDataForToday()
                } label: {
                    Text("Today")
                        .font(.setCustom(fontStyle: .subheadline, fontWeight: .medium))
                        .foregroundColor(Color("TextFieldTextColor"))
                        .padding(8)
                }.overlay{
                    RoundedRectangle(cornerRadius: 5, style: .circular).stroke(Color("BorderColor"), lineWidth: 0.8)
                }.background((selectedWorkSchedule == "Today") ? Color("ButtonDisableColor") : Color.clear)
                
                Button {
                    
                    selectedWorkSchedule = "Week"
                    showWorkScheduleDataForWeek()
                } label: {
                    Text("This week")
                        .font(.setCustom(fontStyle: .subheadline, fontWeight: .medium))
                        .foregroundColor(Color("TextFieldTextColor"))
                        .padding(8)
                }.overlay{
                    RoundedRectangle(cornerRadius: 5, style: .circular).stroke(Color("BorderColor"), lineWidth: 0.8)
                }.background((selectedWorkSchedule == "Week") ? Color("ButtonDisableColor") : Color.clear)
                
                Button {
                    isGettingDataForWorkSchedule = false
                    selectedWorkSchedule = "Month"
                    if getMainAlertDictForMonth.count == 0 {
                        getMonthWorkScheduleArr()
                        getMonthDateData { getAllAlertDict in
                            showWorkScheduleDataForMonth()
                        }
                    }else{
                        showWorkScheduleDataForMonth()
                    }
                    
                } label: {
                    Text("This month")
                        .font(.setCustom(fontStyle: .subheadline, fontWeight: .medium))
                        .foregroundColor(Color("TextFieldTextColor"))
                        .padding(8)
                }.overlay{
                    RoundedRectangle(cornerRadius: 5, style: .circular).stroke(Color("BorderColor"), lineWidth: 0.8)
                }.background((selectedWorkSchedule == "Month") ? Color("ButtonDisableColor") : Color.clear)
                    //.lineLimit(1) // Limit to one line
                                    //.truncationMode(.tail)
                
            }
              
            ZStack{
                
                VStack{
                    //MARK: - Work/Study
                    if isGettingDataForWorkSchedule {
                        VStack{
                            let modelArr : [statsUserStatusModel] = (selectedWorkSchedule == "Today") ? workScheduleUserStatusModelTodayArr : ((selectedWorkSchedule == "Week") ? workScheduleUserStatusModelWeekArr : workScheduleUserStatusModelMonthArr)
                            
                            ForEach(modelArr.indices, id: \.self) { index in
                                let model : statsUserStatusModel = modelArr[index]
                                HStack{
                                    ZStack(alignment: .leading){
                                        RoundedRectangle(cornerRadius: 0)
                                            .fill(Color.white)
                                             .frame(height:25)
                                             .frame(width: 95)
                                             //.padding(8)
                                        Text("\(model.userStatusCount ?? 0) Total")
                                            .font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                                            .foregroundColor(Color("TextFieldTextColor"))
                                            //.padding(8)
                                        
                                    }
                                    
                                    //Spacer()
                                    if (model.userStatusCount ?? 0) == 0{
                                        Text("nil").font(.setCustom(fontStyle: .caption, fontWeight: .regular)).multilineTextAlignment(.leading).foregroundColor(Color("TextFieldTextColor"))
                                            //.padding(.leading, 30)
                                    }else{
                                        let val : Int = model.userStatusCount ?? 0
                                        RoundedRectangle(cornerRadius: 12)
                                             .fill(Color("TopFadeColor"))
                                             .frame(height:20)
                                             //.frame(width: (CGFloat(val * 180) / 100) > 180 ? 180 : (CGFloat((val * 180)) / 100))
                                            .frame(width: (selectedWorkSchedule == "Today") ? ((val > 180) ? CGFloat(180) : CGFloat(val)) : ((selectedWorkSchedule == "Week") ? ((val < 7) ? CGFloat(1) : ((val > 180) ? CGFloat(180) : CGFloat(val / 7))) : ((val < 30) ? CGFloat(1) : ((val > 180) ? CGFloat(180) : CGFloat(val / 30)))))
                                    }
                                    Spacer()
                                    Text(model.userStatusName ?? "")
                                        .font(.setCustom(fontStyle: .callout, fontWeight: .regular))
                                        .foregroundColor(Color("TextFieldTextColor"))
                                        .padding(8)
                                    
                                }
                            }
                        }
                    }
                }
                
                if isLoadingWorkScheduled{
                    Rectangle().fill(Color(.white)).opacity(0.8).frame(height: 200)
                }
                
                ActivityIndicatorView(text: "", isLoading: $isLoadingWorkScheduled)
                    .frame(height: 20)
                    .padding(.top, 15)
            }
            
            
        }.padding()
    }
    
    //MARK: - Get All Alert Today Data For Working Schedule
    func showWorkScheduleDataForToday(){
        if getDataStatus.workScheduleToday == 0{
            isLoadingWorkScheduled = true
            getTodayWorkScheduleArr()
            if getMainAlertDictForToday.count > 0 {
                statsViewModel.getAllStatusCount(getAllAlertArr: getMainAlertDictForToday, monthArr: stepsMonth, weekDateType: DaysType.Today.rawValue, situationType: SituationType.workSchedule.rawValue) { confirmedIgnoreCountArr in
                    workScheduleTodayArr = confirmedIgnoreCountArr
                    if workScheduleTodayArr.count > 0 {
                        workScheduleUserStatusModelTodayArr = [statsUserStatusModel]()
                        for i in 0 ..< workScheduleTodayArr.count {
                            var model : statsUserStatusModel = statsUserStatusModel()
                            model.userStatusCount = workScheduleTodayArr[i] as? Int ?? 0
                            switch i {
                            case 0:
                                model.userStatusName = "Work/Study"
                            case 1:
                                model.userStatusName = "Idle"
                            case 2:
                                model.userStatusName = "On Social Media"
                            case 3:
                                model.userStatusName = "Other"
                            default:
                                break
                            }
                            workScheduleUserStatusModelTodayArr.append(model)
                            //workScheduleModelTodayArr.insert(statsConfirmedIgnoredModel(confirmIgnoreCount: workScheduleTodayArr[i] as? Int ?? 0), at: i)
                        }
                        workScheduleUserStatusModelTodayArr = workScheduleUserStatusModelTodayArr.sorted(by: {$0.userStatusCount ?? 0 > $1.userStatusCount ?? 0})
                        isGettingDataForWorkSchedule = true
                        isLoadingWorkScheduled = false
                        getDataStatus.workScheduleToday = 1
                    }
                }
            }else{
                isGettingDataForWorkSchedule = true
                getTodayWorkScheduleArr()
                isLoadingWorkScheduled = false
            }
        }else{
            isGettingDataForWorkSchedule = true
        }
        showAverageIntensityDataForToday()
    }
    
    //MARK: - Get All Alert Week Data For Working Schedule
    func showWorkScheduleDataForWeek(){
        if getDataStatus.workScheduleWeek == 0{
            isLoadingWorkScheduled = true
            isGettingDataForWorkSchedule = false
            getWeekWorkScheduleArr()
            if getMainAlertDictForWeek.count > 0 {
                statsViewModel.getAllStatusCount(getAllAlertArr: getMainAlertDictForWeek, monthArr: stepsMonth, weekDateType: DaysType.Week.rawValue, situationType: SituationType.workSchedule.rawValue) { confirmedIgnoreCountArr in
                    workScheduleWeekArr = confirmedIgnoreCountArr
                    if workScheduleWeekArr.count > 0 {
                        workScheduleUserStatusModelWeekArr = [statsUserStatusModel]()
                        for i in 0 ..< workScheduleWeekArr.count {
                            var model : statsUserStatusModel = statsUserStatusModel()
                            model.userStatusCount = workScheduleWeekArr[i] as? Int ?? 0
                            switch i {
                            case 0:
                                model.userStatusName = "Work/Study"
                            case 1:
                                model.userStatusName = "Idle"
                            case 2:
                                model.userStatusName = "On Social Media"
                            case 3:
                                model.userStatusName = "Other"
                            default:
                                break
                            }
                            workScheduleUserStatusModelWeekArr.append(model)
                            //workScheduleModelWeekArr.insert(statsConfirmedIgnoredModel(confirmIgnoreCount: workScheduleWeekArr[i] as? Int ?? 0), at: i)
                        }
                        workScheduleUserStatusModelWeekArr = workScheduleUserStatusModelWeekArr.sorted(by: {$0.userStatusCount ?? 0 > $1.userStatusCount ?? 0})
                        isGettingDataForWorkSchedule = true
                        isLoadingWorkScheduled = false
                        getDataStatus.workScheduleWeek = 1
                    }
                }
            }else{
                isGettingDataForWorkSchedule = true
                getWeekWorkScheduleArr()
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(2.0)){
                    isLoadingWorkScheduled = false
                }
            }
        }else{
            isGettingDataForWorkSchedule = true
        }
        
    }
    
    //MARK: - Get All Alert Month Data For WorkSchedule
    func showWorkScheduleDataForMonth(){
        if getDataStatus.workScheduleMonth == 0{
            isLoadingWorkScheduled = true
            isGettingDataForWorkSchedule = false
            getMonthWorkScheduleArr()
            if getMainAlertDictForMonth.count > 0 {
                statsViewModel.getAllStatusCount(getAllAlertArr: getMainAlertDictForMonth, monthArr: stepsMonth, weekDateType: DaysType.Month.rawValue, situationType: SituationType.workSchedule.rawValue) { confirmedIgnoreCountArr in
                    print("confirmedIgnoreCountArr \(confirmedIgnoreCountArr)")
                    workScheduleMonthArr = confirmedIgnoreCountArr
                    if workScheduleMonthArr.count > 0 {
                        workScheduleUserStatusModelMonthArr = [statsUserStatusModel]()
                        for i in 0 ..< workScheduleMonthArr.count {
                            var model : statsUserStatusModel = statsUserStatusModel()
                            model.userStatusCount = workScheduleMonthArr[i] as? Int ?? 0
                            switch i {
                            case 0:
                                model.userStatusName = "Work/Study"
                            case 1:
                                model.userStatusName = "Idle"
                            case 2:
                                model.userStatusName = "On Social Media"
                            case 3:
                                model.userStatusName = "Other"
                            default:
                                break
                            }
                            workScheduleUserStatusModelMonthArr.append(model)
                            //workScheduleModelMonthArr.insert(statsConfirmedIgnoredModel(confirmIgnoreCount: workScheduleMonthArr[i] as? Int ?? 0), at: i)
                        }
                        workScheduleUserStatusModelMonthArr = workScheduleUserStatusModelMonthArr.sorted(by: {$0.userStatusCount ?? 0 > $1.userStatusCount ?? 0})
                        isGettingDataForWorkSchedule = true
                        isLoadingWorkScheduled = false
                        getDataStatus.workScheduleMonth = 1
                    }
                }
            }else{
                isGettingDataForWorkSchedule = true
                getMonthWorkScheduleArr()
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(2.0)){
                    isLoadingWorkScheduled = false
                }
            }
        }else{
            isGettingDataForWorkSchedule = true
        }
    }
}
