//
//  StatisticsView.swift
//  AImAware
//
//  Created by Suyog on 24/05/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI
import Charts

class StatesProgressTracker: ObservableObject {
    static let shared = StatesProgressTracker()
    @Published var isConfirmedIgnoreSelected: Bool = true
    
}

struct StatisticsView: View {
    @State var selectedConfirmedIgnored = "This Week"
    @State var selectedFeeling = "This Week"
    @State var selectedWorkSchedule = "Today"
    @State var selectedAveIntensity = "Today"
    @State var isLoading = true
    @State var isLoadingConfirmedIgnored = false
    @State var isLoadingFeeling = true
    @State var isLoadingWorkScheduled = false
    @State var isLoadingAverageIntensity = false
    @State var isGettingDataForConfimedIgnore = false
    @State var isGettingDataForFeeling = false
    @State var isGettingDataForWorkSchedule = false
    @State var isGettingDataForAverageIntensity = false
    @State var getMainAlertDictForToday = [NSDictionary]()
    @State var getMainAlertDictForWeek = [NSDictionary]()
    @State var getMainAlertDictForMonth = [NSDictionary]()
    @ObservedObject var statsViewModel = StatisticsViewModel.shared
    
    //MARK: - Confirmed Ignore Variables Declaration
    
    let stepsWeekend = [ "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    let stepsWeekendAveIntensity = [ "01", "02", "03", "04", "05", "06", "07", "08", "09", "10"]
    @State var stepsMonth = [statsMonthModel]()
    let steps = [ 2, 1, 5, 8, 3, 9, 5, 9 ]
    var getDataStatus = statsGetDataStatus(confirmedIgnoredWeek: 0,
                                           confirmedIgnoredMonth: 0,
                                           feelingWeek: 0,
                                           feelingMonth: 0,
                                           workScheduleToday: 0,
                                           workScheduleWeek: 0,
                                           workScheduleMonth: 0,
                                           averageIntensityToday: 0,
                                           averageIntensityWeek: 0,
                                           averageIntensityMonth: 0)
    
    @State var confirmedIgnoreModelWeekArr = [statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                              statsConfirmedIgnoredModel(confirmIgnoreCount: 1)]
    @State var confirmedIgnoreModelMonthArr = [statsConfirmedIgnoredModel]()
    
    @State var confirmedIgnoreWeekArr = NSMutableArray()
    @State var confirmedIgnoreMonthArr = NSMutableArray()
    
    //MARK: - Feeling Variables Declaration
    @State var feelingWeekArr = NSMutableArray()
    @State var feelingMonthArr = NSMutableArray()
    
    /*@State var feelingModelWeekArr = [statsConfirmedIgnoredModel]()
    
    @State var feelingModelMonthArr = [statsConfirmedIgnoredModel]()*/
    
    @State var feelingUserStatusModelWeekArr = [statsUserStatusModel]()
    
    @State var feelingUserStatusModelMonthArr = [statsUserStatusModel]()
    
    //MARK: - Working schedule Variables Declaration
    @State var workScheduleTodayArr = NSMutableArray()
    @State var workScheduleWeekArr = NSMutableArray()
    @State var workScheduleMonthArr = NSMutableArray()
    
    /*@State var workScheduleModelTodayArr = [statsConfirmedIgnoredModel]()
    
    @State var workScheduleModelWeekArr = [statsConfirmedIgnoredModel]()
    
    @State var workScheduleModelMonthArr = [statsConfirmedIgnoredModel]()*/
    
    @State var workScheduleUserStatusModelTodayArr = [statsUserStatusModel]()
    
    @State var workScheduleUserStatusModelWeekArr = [statsUserStatusModel]()
    
    @State var workScheduleUserStatusModelMonthArr = [statsUserStatusModel]()
    
    //MARK: - Average Intensity Variables Declaration
    @State var averageIntensityTodayArr = NSMutableArray()
    @State var averageIntensityWeekArr = NSMutableArray()
    @State var averageIntensityMonthArr = NSMutableArray()
    
    @State var averageIntensityModelTodayArr = [statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                                statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                                statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                                statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                                statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                                statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                                statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                                statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                                statsConfirmedIgnoredModel(confirmIgnoreCount: 1),
                                                statsConfirmedIgnoredModel(confirmIgnoreCount: 1)]
    
    @State var averageIntensityModelWeekArr = [statsConfirmedIgnoredModel]()
    
    @State var averageIntensityModelMonthArr = [statsConfirmedIgnoredModel]()
    
    @ObservedObject var statesProgressTracker = StatesProgressTracker.shared
    
    var body: some View {
        ZStack{
            
            ScrollView{
                VStack{
                    headerView()
                    commonFeeling()
                    workingSchedule()
                    averageIntensity()
                }.onAppear{
                    getAllVariables()
                    getWeekDateData() { getAllAlertDict in
                        showConfirmedIgnoreDataForWeek()
                        getTodayDateData { getAllAlertDict in
                            showWorkScheduleDataForToday()
                        }
                    }
                }
            }
            
            if isLoading{
                Rectangle().fill(Color(.white)).opacity(0.8)
            }
            
            ActivityIndicatorView(text: "Loading...", isLoading: $isLoading)
                .frame(height: 20)
                .padding(.top, 15)
        }
        
    }
    
    func getAllVariables(){
        selectedConfirmedIgnored = "This Week"
        selectedFeeling = "This Week"
        selectedWorkSchedule = "Today"
        selectedAveIntensity = "Today"
        isLoading = true
        isLoadingConfirmedIgnored = false
        isLoadingFeeling = true
        isLoadingWorkScheduled = false
        isLoadingAverageIntensity = false
        isGettingDataForConfimedIgnore = false
        isGettingDataForFeeling = false
        isGettingDataForWorkSchedule = false
        isGettingDataForAverageIntensity = false
        getMainAlertDictForToday = [NSDictionary]()
        getMainAlertDictForWeek = [NSDictionary]()
        getMainAlertDictForMonth = [NSDictionary]()
        getDataStatus.confirmedIgnoredWeek = 0
        getDataStatus.confirmedIgnoredMonth = 0
        getDataStatus.feelingWeek = 0
        getDataStatus.feelingMonth = 0
        getDataStatus.workScheduleToday = 0
        getDataStatus.workScheduleWeek = 0
        getDataStatus.workScheduleMonth = 0
        getDataStatus.averageIntensityToday = 0
        getDataStatus.averageIntensityWeek = 0
        getDataStatus.averageIntensityMonth = 0
        getWeekArr()
        getMonthArr()
        getWeekFeelingArr()
        getMonthFeelingArr()
        getTodayWorkScheduleArr()
        getWeekWorkScheduleArr()
        getMonthWorkScheduleArr()
        getTodayAverageIntensityArr()
        getWeekAverageIntensityArr()
        getMonthAverageIntensityArr()
    }
    
    
    func headerView() -> some View {
        VStack() {
            Text("Statistics").font(.setCustom(fontStyle: .title, fontWeight: .medium))
                .foregroundColor(Color("MainTextColor"))
            HStack{
                Text("When did it happen").font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                    .foregroundColor(Color("MainTextColor"))
                Spacer()
                Menu {
                    Button("This Week", action: getWeeks).frame(minWidth: 0,
                                                                   maxWidth: .infinity)
                    Button("This Month", action: getMonth).frame(minWidth: 0,
                                                                       maxWidth: .infinity)

                } label: {
                    HStack {
                        Text(selectedConfirmedIgnored)
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
            
            Text("Nudges/h - including all confirmed and ignored alerts of this week").font(.setCustom(fontStyle: .subheadline, fontWeight: .regular)).foregroundColor(Color("TextFieldTextColor"))//.padding(.leading, 2)
            
            //MARK: - For Showing Confirmed and ignored data
            ZStack{
                ScrollView(.horizontal) {
                    Chart{
                        if selectedConfirmedIgnored == "This Week"{
                            if !(confirmedIgnoreModelWeekArr.filter({$0.confirmIgnoreCount != 1}).count > 0) || !isGettingDataForConfimedIgnore{
                                ForEach(stepsWeekend.indices, id: \.self) { index in
                                    let model = confirmedIgnoreModelWeekArr[index]
                                    BarMark(x: .value("Day", stepsWeekend[index]), y: .value("Steps", model.confirmIgnoreCount ?? 0), width: .fixed(40))
                                    
                                       // .cornerRadius(5)
                                        .foregroundStyle(Color.clear)
                                        .annotation(position: .top) {
                                            Text("nil").font(.setCustom(fontStyle: .caption, fontWeight: .regular)).multilineTextAlignment(.leading).foregroundColor(Color("TextFieldTextColor"))
                                        }
                                        
                                }
                            }else{
                                ForEach(stepsWeekend.indices, id: \.self) { index in
                                    let model = confirmedIgnoreModelWeekArr[index]
                                    if model.confirmIgnoreCount == 0 {
                                        BarMark(x: .value("Day", stepsWeekend[index]), y: .value("Steps", model.confirmIgnoreCount ?? 0), width: .fixed(40))
                                            .cornerRadius(5)
                                            .annotation(position: .top) {
                                                Text("nil").font(.setCustom(fontStyle: .caption, fontWeight: .regular)).multilineTextAlignment(.leading).foregroundColor(Color("TextFieldTextColor"))
                                            }
                                    }else{
                                        BarMark(x: .value("Day", stepsWeekend[index]), y: .value("Steps", model.confirmIgnoreCount ?? 0), width: .fixed(40))
                                            .cornerRadius(5)
                                            .foregroundStyle(Color("TopFadeColor"))
                                            
                                    }
                                }
                            }
                        }else{
                            if !(confirmedIgnoreModelMonthArr.filter({$0.confirmIgnoreCount != 1}).count > 0) || !isGettingDataForConfimedIgnore{
                                ForEach(stepsMonth.indices, id: \.self) { index in
                                    let model = confirmedIgnoreModelMonthArr[index]
                                    let monthModel = stepsMonth[index]
                                    BarMark(x: .value("Day", monthModel.monthStr ?? ""), y: .value("Steps", model.confirmIgnoreCount ?? 0), width: .fixed(40))
                                       // .cornerRadius(5)
                                        .foregroundStyle(Color.clear)
                                        .annotation(position: .top) {
                                            Text("nil").font(.setCustom(fontStyle: .caption, fontWeight: .regular)).multilineTextAlignment(.leading).foregroundColor(Color("TextFieldTextColor"))
                                        }
                                }
                            }else{
                                ForEach(stepsMonth.indices, id: \.self) { index in
                                    let model = confirmedIgnoreModelMonthArr[index]
                                    let monthModel = stepsMonth[index]
                                    if model.confirmIgnoreCount == 0 {
                                        BarMark(x: .value("Day", monthModel.monthStr ?? ""), y: .value("Steps", model.confirmIgnoreCount ?? 0), width: .fixed(40))
                                            .cornerRadius(5)
                                            .annotation(position: .top) {
                                                Text("nil").font(.setCustom(fontStyle: .caption, fontWeight: .regular)).multilineTextAlignment(.leading).foregroundColor(Color("TextFieldTextColor"))
                                            }
                                    }else{
                                        BarMark(x: .value("Day", monthModel.monthStr ?? ""), y: .value("Steps", model.confirmIgnoreCount ?? 0), width: .fixed(40))
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
                        if selectedConfirmedIgnored == "Week"{
                            AxisMarks(position: .bottom, values: stepsWeekend) { value in
                                AxisValueLabel(stepsWeekend[value.index])
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
                            /*AxisMarks(position: .bottom, values: stepsMonth) { value in
                                let model = stepsMonth[value.index]
                                AxisValueLabel(model.monthStr)
                            }*/
                        }
                    }
                    //.chartScrollableAxes(.horizontal)
                    //.chartXVisibleDomain(length: 6)
                    
                    .frame(width: (selectedConfirmedIgnored == "This Week") ? CGFloat(stepsWeekend.count) * 50 : CGFloat(stepsMonth.count) * 50)
                }
                
                if isLoadingConfirmedIgnored{
                    Rectangle().fill(Color(.white)).opacity(0.8)
                }
                
                ActivityIndicatorView(text: "", isLoading: $isLoadingConfirmedIgnored)
                    .frame(height: 20)
                    .padding(.top, 15)
                
            }
            
        }.padding()
    }
    
    
    //MARK: - Get Today, Week and Month Data
    func getTodayDateData( completion: @escaping( _ getAllAlertDict : [NSDictionary]) -> Void){
        StatsDatabaseManager.shared.getCurrentDate() { getAllAlertDict in
            getMainAlertDictForToday = [NSDictionary]()
            getMainAlertDictForToday = getAllAlertDict
            completion(getMainAlertDictForToday)
            
        }
    }
    
    func getWeekDateData( completion: @escaping( _ getAllAlertDict : [NSDictionary]) -> Void){
        DatabaseManager.shared.getCurrentWeekDates() { getAllAlertDict in
            getMainAlertDictForWeek = [NSDictionary]()
            getMainAlertDictForWeek = getAllAlertDict
            UserDefaults.standard.set(true, forKey: "isSetWeekModule")
            print(getMainAlertDictForWeek)
            completion(getMainAlertDictForWeek)
        }
    }
    
    func getMonthDateData( completion: @escaping( _ getAllAlertDict : [NSDictionary]) -> Void){
        StatsMonthDatabaseManager.shared.getCurrentMonthDates { getAllAlertDict, monthArr in
            getMainAlertDictForMonth = [NSDictionary]()
            getMainAlertDictForMonth = getAllAlertDict
            stepsMonth = [statsMonthModel]()
            for data in monthArr {
                let model : statsMonthModel = statsMonthModel(monthStr: data)
                stepsMonth.append(model)
            }
            completion(getMainAlertDictForMonth)
        }
    }
    
    
    //MARK: - Get All Alert Week Data For ConfirmedIgnore
    func showConfirmedIgnoreDataForWeek(){
        if getDataStatus.confirmedIgnoredWeek == 0{
            getWeekArr()
            if getMainAlertDictForWeek.count > 0 {
                statsViewModel.getAllStatusCount(getAllAlertArr: getMainAlertDictForWeek, monthArr: [], weekDateType:DaysType.Week.rawValue, situationType: SituationType.confirmedIgnore.rawValue) { confirmedIgnoreCountArr in
                    confirmedIgnoreWeekArr = confirmedIgnoreCountArr
                    if confirmedIgnoreWeekArr.count > 0 {
                        for i in 0 ..< confirmedIgnoreWeekArr.count {
                            if confirmedIgnoreWeekArr[i] as? Int ?? 0 > 20 {
                                confirmedIgnoreModelWeekArr.insert(statsConfirmedIgnoredModel(confirmIgnoreCount: 20), at: i)
                            }else{
                                confirmedIgnoreModelWeekArr.insert(statsConfirmedIgnoredModel(confirmIgnoreCount: confirmedIgnoreWeekArr[i] as? Int ?? 0), at: i)
                            }
                            
                        }
                        getDataStatus.confirmedIgnoredWeek = 1
                        isGettingDataForConfimedIgnore = true
                    }
                }
            }else{
                isGettingDataForConfimedIgnore = true
                getWeekArr()
            }
            
        }else{
            isGettingDataForConfimedIgnore = true
        }
        showCommonFeelingDataForWeek()
    }
    
    //MARK: - Get All Alert Month Data For ConfirmedIgnore
    func showConfirmedIgnoreDataForMonth(){
        if getDataStatus.confirmedIgnoredMonth == 0{
            getMonthArr()
            if getMainAlertDictForMonth.count > 0 {
                statsViewModel.getAllStatusCount(getAllAlertArr: getMainAlertDictForMonth, monthArr: stepsMonth, weekDateType: DaysType.Month.rawValue, situationType: SituationType.confirmedIgnore.rawValue) { confirmedIgnoreCountArr in
                    print(confirmedIgnoreCountArr)
                    confirmedIgnoreMonthArr = confirmedIgnoreCountArr
                    if confirmedIgnoreMonthArr.count > 0 {
                        for i in 0 ..< confirmedIgnoreMonthArr.count {
                            if confirmedIgnoreMonthArr[i] as? Int ?? 0 > 20 {
                                confirmedIgnoreModelMonthArr.insert(statsConfirmedIgnoredModel(confirmIgnoreCount: 20), at: i)
                            }else{
                                confirmedIgnoreModelMonthArr.insert(statsConfirmedIgnoredModel(confirmIgnoreCount: confirmedIgnoreMonthArr[i] as? Int ?? 0), at: i)
                            }
                            
                        }
                        print(confirmedIgnoreModelMonthArr)
                        isGettingDataForConfimedIgnore = true
                        getDataStatus.confirmedIgnoredMonth = 1
                    }
                }
            }else{
                isGettingDataForConfimedIgnore = true
                getMonthArr()
            }
        }else{
            isGettingDataForConfimedIgnore = true
        }
        
    }
    
    func getToday() {
        isGettingDataForWorkSchedule = false
        selectedConfirmedIgnored = "This Week"
        getTodayDateData() { getAllAlertDict in
            showWorkScheduleDataForWeek()
        }
    }
    
    func getWeeks() {
        isLoadingConfirmedIgnored = true
        isGettingDataForConfimedIgnore = false
        selectedConfirmedIgnored = "This Week"
        getWeekDateData() { getAllAlertDict in
            isLoadingConfirmedIgnored = false
            showConfirmedIgnoreDataForWeek()
        }
    }
    
    func getMonth() {
        isLoadingConfirmedIgnored = true
        isGettingDataForConfimedIgnore = false
        selectedConfirmedIgnored = "This Month"
        if getMainAlertDictForMonth.count == 0 {
            getMonthArr()
            getMonthDateData { getAllAlertDict in
                showConfirmedIgnoreDataForMonth()
                isLoadingConfirmedIgnored = false
            }
        }else{
            isLoadingConfirmedIgnored = false
            showConfirmedIgnoreDataForMonth()
        }
    }
}

#Preview {
    StatisticsView()
}

