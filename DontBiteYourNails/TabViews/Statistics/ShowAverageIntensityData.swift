//
//  ShowAverageIntensityData.swift
//  AImAware
//
//  Created by Suyog on 12/06/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI
import Charts

extension StatisticsView {
    
    //MARK: - For Showing Average Intensity
    func averageIntensity() -> some View{
        VStack() {
            HStack{
                Text("Average Intensity").font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                    .foregroundColor(Color("MainTextColor"))
                Spacer(minLength: 2)
                
                Button {
                    selectedAveIntensity = "Today"
                    showAverageIntensityDataForToday()
                } label: {
                    Text("Today")
                        .font(.setCustom(fontStyle: .subheadline, fontWeight: .medium))
                        .foregroundColor(Color("TextFieldTextColor"))
                        .padding(8)
                }.overlay{
                    RoundedRectangle(cornerRadius: 5, style: .circular).stroke(Color("BorderColor"), lineWidth: 0.8)
                }.background((selectedAveIntensity == "Today") ? Color("ButtonDisableColor") : Color.clear)
                
                Button {
                    selectedAveIntensity = "Week"
                    showAverageIntensityDataForWeek()
                } label: {
                    Text("This week")
                        .font(.setCustom(fontStyle: .subheadline, fontWeight: .medium))
                        .foregroundColor(Color("TextFieldTextColor"))
                        .padding(8)
                }.overlay{
                    RoundedRectangle(cornerRadius: 5, style: .circular).stroke(Color("BorderColor"), lineWidth: 0.8)
                }.background((selectedAveIntensity == "Week") ? Color("ButtonDisableColor") : Color.clear)
                
                Button {
                    isGettingDataForAverageIntensity = false
                    selectedAveIntensity = "Month"
                    if getMainAlertDictForMonth.count == 0 {
                        getMonthAverageIntensityArr()
                        getMonthDateData { getAllAlertDict in
                            showAverageIntensityDataForMonth()
                        }
                    }else{
                        showAverageIntensityDataForMonth()
                    }
                    
                } label: {
                    Text("This month")
                        .font(.setCustom(fontStyle: .subheadline, fontWeight: .medium))
                        .foregroundColor(Color("TextFieldTextColor"))
                        .padding(8)
                }.overlay{
                    RoundedRectangle(cornerRadius: 5, style: .circular).stroke(Color("BorderColor"), lineWidth: 0.8)
                }.background((selectedAveIntensity == "Month") ? Color("ButtonDisableColor") : Color.clear)
                    //.lineLimit(1) // Limit to one line
                                    //.truncationMode(.tail)
                
            }
            
            Text("How intense is the urge to perform the habit from 1-10 with the 1 being lowest and 10 being the highest").font(.setCustom(fontStyle: .subheadline, fontWeight: .regular)).foregroundColor(Color("TextFieldTextColor"))//.padding(.leading, 2)
            
            //MARK: - For Showing Average Intensity data
            ZStack{
                ScrollView(.horizontal) {
                    Chart{
                        if selectedAveIntensity == "Today"{
                            if !(averageIntensityModelTodayArr.filter({$0.confirmIgnoreCount != 1}).count > 0) || !isGettingDataForAverageIntensity{
                                ForEach(stepsWeekendAveIntensity.indices, id: \.self) { index in
                                    let model = averageIntensityModelTodayArr[index]
                                    BarMark(x: .value("Day", stepsWeekendAveIntensity[index]), y: .value("Steps", model.confirmIgnoreCount ?? 0), width: .fixed(40))
                                       // .cornerRadius(5)
                                        .foregroundStyle(Color.clear)
                                        .annotation(position: .top) {
                                            Text("nil").font(.setCustom(fontStyle: .caption, fontWeight: .regular)).multilineTextAlignment(.leading).foregroundColor(Color("TextFieldTextColor"))
                                        }
                                }
                            }else{
                                ForEach(stepsWeekendAveIntensity.indices, id: \.self) { index in
                                    let model = averageIntensityModelTodayArr[index]
                                    if model.confirmIgnoreCount == 0 {
                                        BarMark(x: .value("Day", stepsWeekendAveIntensity[index]), y: .value("Steps", model.confirmIgnoreCount ?? 0), width: .fixed(40))
                                            .cornerRadius(5)
                                            .annotation(position: .top) {
                                                Text("nil").font(.setCustom(fontStyle: .caption, fontWeight: .regular)).multilineTextAlignment(.leading).foregroundColor(Color("TextFieldTextColor"))
                                            }
                                    }else{
                                        BarMark(x: .value("Day", stepsWeekendAveIntensity[index]), y: .value("Steps", model.confirmIgnoreCount ?? 0), width: .fixed(40))
                                            .cornerRadius(5)
                                            .foregroundStyle(Color("TopFadeColor"))
                                            
                                    }
                                }
                            }
                        }else if selectedAveIntensity == "Week"{
                            if !(averageIntensityModelWeekArr.filter({$0.confirmIgnoreCount != 1}).count > 0) || !isGettingDataForAverageIntensity{
                                ForEach(stepsWeekendAveIntensity.indices, id: \.self) { index in
                                    let model = averageIntensityModelWeekArr[index]
                                    BarMark(x: .value("Day", stepsWeekendAveIntensity[index]), y: .value("Steps", model.confirmIgnoreCount ?? 0), width: .fixed(40))
                                       // .cornerRadius(5)
                                        .foregroundStyle(Color.clear)
                                        .annotation(position: .top) {
                                            Text("nil").font(.setCustom(fontStyle: .caption, fontWeight: .regular)).multilineTextAlignment(.leading).foregroundColor(Color("TextFieldTextColor"))
                                        }
                                }
                            }else{
                                ForEach(stepsWeekendAveIntensity.indices, id: \.self) { index in
                                    let model = averageIntensityModelWeekArr[index]
                                    if model.confirmIgnoreCount == 0 {
                                        BarMark(x: .value("Day", stepsWeekendAveIntensity[index]), y: .value("Steps", model.confirmIgnoreCount ?? 0), width: .fixed(40))
                                            .cornerRadius(5)
                                            .annotation(position: .top) {
                                                Text("nil").font(.setCustom(fontStyle: .caption, fontWeight: .regular)).multilineTextAlignment(.leading).foregroundColor(Color("TextFieldTextColor"))
                                            }
                                    }else{
                                        BarMark(x: .value("Day", stepsWeekendAveIntensity[index]), y: .value("Steps", model.confirmIgnoreCount ?? 0), width: .fixed(40))
                                            .cornerRadius(5)
                                            .foregroundStyle(Color("TopFadeColor"))
                                            
                                    }
                                }
                            }
                        }else{
                            if !(averageIntensityModelMonthArr.filter({$0.confirmIgnoreCount != 1}).count > 0) || !isGettingDataForAverageIntensity{
                                ForEach(stepsWeekendAveIntensity.indices, id: \.self) { index in
                                    let model = averageIntensityModelMonthArr[index]
                                    BarMark(x: .value("Day", stepsWeekendAveIntensity[index]), y: .value("Steps", model.confirmIgnoreCount ?? 0), width: .fixed(40))
                                       // .cornerRadius(5)
                                        .foregroundStyle(Color.clear)
                                        .annotation(position: .top) {
                                            Text("nil").font(.setCustom(fontStyle: .caption, fontWeight: .regular)).multilineTextAlignment(.leading).foregroundColor(Color("TextFieldTextColor"))
                                        }
                                }
                            }else{
                                ForEach(stepsWeekendAveIntensity.indices, id: \.self) { index in
                                    let model = averageIntensityModelMonthArr[index]
                                    if model.confirmIgnoreCount == 0 {
                                        BarMark(x: .value("Day", stepsWeekendAveIntensity[index]), y: .value("Steps", model.confirmIgnoreCount ?? 0), width: .fixed(40))
                                            .cornerRadius(5)
                                            .annotation(position: .top) {
                                                Text("nil").font(.setCustom(fontStyle: .caption, fontWeight: .regular)).multilineTextAlignment(.leading).foregroundColor(Color("TextFieldTextColor"))
                                            }
                                    }else{
                                        BarMark(x: .value("Day", stepsWeekendAveIntensity[index]), y: .value("Steps", model.confirmIgnoreCount ?? 0), width: .fixed(40))
                                            .cornerRadius(5)
                                            .foregroundStyle(Color("TopFadeColor"))
                                            
                                    }
                                }
                            }
                        }
                    }
                    .chartYAxis{
                        AxisMarks(position: .leading, values: Array(stride(from: 0, through: 20, by: 5))) { _ in
                            AxisValueLabel(centered: false)
                        }
                    }.padding(.top, 10)
                        .frame(height: 150)
                    .chartXAxis{
                        if selectedAveIntensity == "Week"{
                            AxisMarks(position: .bottom, values: stepsWeekendAveIntensity) { value in
                                AxisValueLabel(stepsWeekendAveIntensity[value.index])
                            }
                        }else{
                            AxisMarks{ value in
                                
                                AxisValueLabel {
                                    
                                    if let month = value.as(String.self) {
                                        
                                        Text(month)
                                        
                                           // .rotationEffect(Angle(degrees: 60))
                                        
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: CGFloat(stepsWeekendAveIntensity.count) * 50)
                }
                
                if isLoadingAverageIntensity{
                    Rectangle().fill(Color(.white)).opacity(0.8).frame(height: 200)
                }
                
                ActivityIndicatorView(text: "", isLoading: $isLoadingAverageIntensity)
                    .frame(height: 20)
                    .padding(.top, 15)
            }
        }.padding()
    }
    
    
    //MARK: - Get All Alert Today Data For Average Intensity
    func showAverageIntensityDataForToday(){
        if getDataStatus.averageIntensityToday == 0{
            isLoadingAverageIntensity = true
            getTodayAverageIntensityArr()
            if getMainAlertDictForToday.count > 0 {
                statsViewModel.getAllStatusCount(getAllAlertArr: getMainAlertDictForToday, monthArr: stepsMonth, weekDateType: DaysType.Today.rawValue, situationType: SituationType.averageIntensity.rawValue) { confirmedIgnoreCountArr in
                    averageIntensityTodayArr = confirmedIgnoreCountArr
                    if averageIntensityTodayArr.count > 0 {
                        averageIntensityModelTodayArr = [statsConfirmedIgnoredModel]()
                        for i in 0 ..< averageIntensityTodayArr.count {
                            if averageIntensityTodayArr[i] as? Int ?? 0 > 20 {
                                averageIntensityModelTodayArr.insert(statsConfirmedIgnoredModel(confirmIgnoreCount: 20), at: i)
                            }else{
                                averageIntensityModelTodayArr.insert(statsConfirmedIgnoredModel(confirmIgnoreCount: averageIntensityTodayArr[i] as? Int ?? 0), at: i)
                            }
                            
                        }
                        isGettingDataForAverageIntensity = true
                        isLoading = false
                        isLoadingAverageIntensity = false
                        getDataStatus.averageIntensityToday = 1
                    }
                }
            }else{
                isGettingDataForAverageIntensity = true
                getTodayAverageIntensityArr()
                isLoading = false
                isLoadingAverageIntensity = false
            }
        }else{
            isGettingDataForAverageIntensity = true
        }
        
    }
    
    //MARK: - Get All Alert Week Data For Average Intensity
    func showAverageIntensityDataForWeek(){
        if getDataStatus.averageIntensityWeek == 0{
            isLoadingAverageIntensity = true
            isGettingDataForAverageIntensity = false
            getWeekAverageIntensityArr()
            if getMainAlertDictForWeek.count > 0 {
                statsViewModel.getAllStatusCount(getAllAlertArr: getMainAlertDictForWeek, monthArr: stepsMonth, weekDateType: DaysType.Week.rawValue, situationType: SituationType.averageIntensity.rawValue) { confirmedIgnoreCountArr in
                    averageIntensityWeekArr = confirmedIgnoreCountArr
                    if averageIntensityWeekArr.count > 0 {
                        for i in 0 ..< averageIntensityWeekArr.count {
                            if averageIntensityWeekArr[i] as? Int ?? 0 > 20 {
                                averageIntensityModelWeekArr.insert(statsConfirmedIgnoredModel(confirmIgnoreCount: 20), at: i)
                            }else{
                                averageIntensityModelWeekArr.insert(statsConfirmedIgnoredModel(confirmIgnoreCount: averageIntensityWeekArr[i] as? Int ?? 0), at: i)
                            }
                            
                        }
                        isGettingDataForAverageIntensity = true
                        isLoadingAverageIntensity = false
                        getDataStatus.averageIntensityWeek = 1
                    }
                }
            }else{
                isGettingDataForAverageIntensity = true
                getWeekAverageIntensityArr()
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(2.0)){
                    isLoadingAverageIntensity = false
                }
                
            }
        }else{
            isGettingDataForAverageIntensity = true
        }
        
    }
    
    //MARK: - Get All Alert Month Data For Average Intensity
    func showAverageIntensityDataForMonth(){
        if getDataStatus.averageIntensityMonth == 0{
            isLoadingAverageIntensity = true
            getMonthAverageIntensityArr()
            if getMainAlertDictForMonth.count > 0 {
                statsViewModel.getAllStatusCount(getAllAlertArr: getMainAlertDictForMonth, monthArr: stepsMonth, weekDateType: DaysType.Month.rawValue, situationType: SituationType.averageIntensity.rawValue) { confirmedIgnoreCountArr in
                    averageIntensityMonthArr = confirmedIgnoreCountArr
                    if averageIntensityMonthArr.count > 0 {
                        averageIntensityModelMonthArr = [statsConfirmedIgnoredModel]()
                        for i in 0 ..< averageIntensityMonthArr.count {
                            if averageIntensityMonthArr[i] as? Int ?? 0 > 20 {
                                averageIntensityModelMonthArr.insert(statsConfirmedIgnoredModel(confirmIgnoreCount: 20), at: i)
                            }else{
                                averageIntensityModelMonthArr.insert(statsConfirmedIgnoredModel(confirmIgnoreCount: averageIntensityMonthArr[i] as? Int ?? 0), at: i)
                            }
                            
                        }
                        
                        isGettingDataForAverageIntensity = true
                        isLoadingAverageIntensity = false
                        getDataStatus.averageIntensityMonth = 1
                    }
                }
            }else{
                getMonthAverageIntensityArr()
                isGettingDataForAverageIntensity = true
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(2.0)){
                    isLoadingAverageIntensity = false
                }
            }
        }else{
            isGettingDataForAverageIntensity = true
        }
    }
}
