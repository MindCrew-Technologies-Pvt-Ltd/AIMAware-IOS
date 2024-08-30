//
//  CustomDropDownFeeling.swift
//  AImAware
//
//  Created by Suyog on 11/06/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

//MARK: - For Showing Most Common Feeling data
extension StatisticsView {
    func commonFeeling() -> some View{
        VStack() {
            HStack{
                Text("Most common feeling").font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                    .foregroundColor(Color("MainTextColor"))
                Spacer()
                Menu {
                    Button("This Week", action: getWeeksForFeeling).frame(minWidth: 0,
                                                                   maxWidth: .infinity)
                    Button("This Month", action: getMonthForFeeling).frame(minWidth: 0,
                                                                       maxWidth: .infinity)

                } label: {
                    HStack {
                        Text(selectedFeeling)
                            .font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                            .foregroundColor(Color("TextFieldTextColor"))
                            .padding(8)
                        Image("down")
                            .padding(8)
                    }
                }.overlay{
                    RoundedRectangle(cornerRadius: 5, style: .circular).stroke(Color("BorderColor"), lineWidth: 0.8)
                }
            }
                
            ZStack{
                
                VStack{
                    //MARK: - Anxious
                    if isGettingDataForFeeling {
                        VStack{
                            let modelArr : [statsUserStatusModel] = (selectedFeeling == "This Week") ? feelingUserStatusModelWeekArr : feelingUserStatusModelMonthArr
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
                                    
                                    if model.userStatusCount ?? 0 == 0  {
                                        Text("nil").font(.setCustom(fontStyle: .caption, fontWeight: .regular)).multilineTextAlignment(.leading).foregroundColor(Color("TextFieldTextColor")) //.padding(.leading, 24)
                                    }else{
                                        let val : Int = model.userStatusCount ?? 0
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color("TopFadeColor"))
                                            .frame(height:20)
                                            //.frame(width: (CGFloat((val * 180)) / 100) > 180 ? 180 : (CGFloat((val * 180)) / 100))
                                            .frame(width: (selectedFeeling == "This Week") ? ((val < 7) ? CGFloat(1) : ((val > 180) ? CGFloat(180) : CGFloat(val / 7))) : ((val < 30) ? CGFloat(1) : ((val > 180) ? CGFloat(180) : CGFloat(val / 30))))
                                    }
                                    
                                    Spacer(minLength: 30)
                                    Text(model.userStatusName ?? "")
                                        .font(.setCustom(fontStyle: .callout, fontWeight: .regular))
                                        .foregroundColor(Color("TextFieldTextColor"))
                                        .padding(8)
                                    
                                }
                            }
                        }
                    }
                }
                
                if isLoadingFeeling{
                    Rectangle().fill(Color(.white)).opacity(0.8).frame(height: 200)
                }
                
                ActivityIndicatorView(text: "", isLoading: $isLoadingFeeling)
                    .frame(height: 20)
                    .padding(.top, 15)
            }
            
            
        }.padding()
    }
    
    //MARK: - Get All Alert Week Data For Feeling
    func showCommonFeelingDataForWeek(){
        if getDataStatus.feelingWeek == 0{
            isLoadingFeeling = true
            getWeekFeelingArr()
            if getMainAlertDictForWeek.count > 0 {
                statsViewModel.getAllStatusCount(getAllAlertArr: getMainAlertDictForWeek, monthArr: stepsMonth, weekDateType: DaysType.Week.rawValue, situationType: SituationType.feeling.rawValue) { confirmedIgnoreCountArr in
                    feelingWeekArr = confirmedIgnoreCountArr
                    
                    if feelingWeekArr.count > 0 {
                        feelingUserStatusModelWeekArr = [statsUserStatusModel]()
                        for i in 0 ..< feelingWeekArr.count {
                            var model : statsUserStatusModel = statsUserStatusModel()
                            model.userStatusCount = feelingWeekArr[i] as? Int ?? 0
                            switch i {
                            case 0:
                                model.userStatusName = "Anxious"
                            case 1:
                                model.userStatusName = "Stressed"
                            case 2:
                                model.userStatusName = "Frustrated"
                            case 3:
                                model.userStatusName = "Bored"
                            case 4:
                                model.userStatusName = "Sad"
                            case 5:
                                model.userStatusName = "Tired"
                            case 6:
                                model.userStatusName = "Other"
                            default:
                                break
                            }
                            feelingUserStatusModelWeekArr.append(model)
                            //feelingModelWeekArr.insert(statsConfirmedIgnoredModel(confirmIgnoreCount: feelingWeekArr[i] as? Int ?? 0), at: i)
                            
                        }
                        feelingUserStatusModelWeekArr = feelingUserStatusModelWeekArr.sorted(by: {$0.userStatusCount ?? 0 > $1.userStatusCount ?? 0})
                        print(feelingUserStatusModelWeekArr)
                        isGettingDataForFeeling = true
                        isLoadingFeeling = false
                        getDataStatus.feelingWeek = 1
                    }
                }
            }else{
                getWeekFeelingArr()
                isGettingDataForFeeling = true
                //DispatchQueue.main.asyncAfter(deadline: .now() + Double(4.0)){
                    isLoadingFeeling = false
               // }
            }
        }else{
            isGettingDataForFeeling = true
        }
        
        //showWorkScheduleDataForToday()
    }
    
    //MARK: - Get All Alert Month Data For Feeling
    func showCommonFeelingDataForMonth(){
        if getDataStatus.feelingMonth == 0{
            isLoadingFeeling = true
            getMonthFeelingArr()
            if getMainAlertDictForMonth.count > 0 {
                statsViewModel.getAllStatusCount(getAllAlertArr: getMainAlertDictForMonth, monthArr: stepsMonth, weekDateType: DaysType.Month.rawValue, situationType: SituationType.feeling.rawValue) { confirmedIgnoreCountArr in
                    feelingMonthArr = confirmedIgnoreCountArr
                    if feelingMonthArr.count > 0 {
                        
                        feelingUserStatusModelMonthArr = [statsUserStatusModel]()
                        for i in 0 ..< feelingMonthArr.count {
                            var model : statsUserStatusModel = statsUserStatusModel()
                            model.userStatusCount = feelingMonthArr[i] as? Int ?? 0
                            switch i {
                            case 0:
                                model.userStatusName = "Anxious"
                            case 1:
                                model.userStatusName = "Stressed"
                            case 2:
                                model.userStatusName = "Frustrated"
                            case 3:
                                model.userStatusName = "Bored"
                            case 4:
                                model.userStatusName = "Sad"
                            case 5:
                                model.userStatusName = "Tired"
                            case 6:
                                model.userStatusName = "Other"
                            default:
                                break
                            }
                            feelingUserStatusModelMonthArr.append(model)
                            //feelingModelMonthArr.insert(statsConfirmedIgnoredModel(confirmIgnoreCount: feelingMonthArr[i] as? Int ?? 0), at: i)
                        }
                        feelingUserStatusModelMonthArr = feelingUserStatusModelMonthArr.sorted(by: {$0.userStatusCount ?? 0 > $1.userStatusCount ?? 0})
                        isGettingDataForFeeling = true
                        isLoadingFeeling = false
                        getDataStatus.feelingMonth = 1
                    }
                }
            }else{
                isGettingDataForFeeling = true
                getMonthFeelingArr()
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(2.0)){
                    isLoadingFeeling = false
                }
            }
        }else{
            isGettingDataForFeeling = true
        }
        
    }
    
    func getWeeksForFeeling() {
        isGettingDataForFeeling = false
        selectedFeeling = "This Week"
        showCommonFeelingDataForWeek()
    }
    
    func getMonthForFeeling() {
        isGettingDataForFeeling = false
        selectedFeeling = "This Month"
        if getMainAlertDictForMonth.count == 0 {
            getMonthDateData { getAllAlertDict in
                showCommonFeelingDataForMonth()
            }
        }else{
            showCommonFeelingDataForMonth()
        }
    }
}

