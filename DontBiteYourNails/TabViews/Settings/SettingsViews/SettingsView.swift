//
//  SettingsView.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 27/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI
import WatchConnectivity
struct SettingsView: View {
    @State private var sliderValue: Double = .zero
    @EnvironmentObject var homeRouter: NavigationHomeRouter
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    @State private var reminderStatus = false
    @State var editReminderArr = [[String: Any]]()
    private var setttingDataUpdateObserver: NSObjectProtocol?
    @ObservedObject var settings = PhoneSettings.shared
    @StateObject var settingsViewModel = SettingsViewModel()
    @State private var isLoading = false
    @State private var isReminderLoading = false
    var body: some View {
        ScrollView {
            ZStack{
                VStack(){
                    
                    backButton()
                    nudgeSetting()
                    sliderSetting()
                    reminderSetting()
                    managedSetting()
                    
                }.navigationBarHidden(true)
                .onAppear{
                    AnalyticsHelper.logCreatedEvent(key: "view_setting", value: SignUpCompleteViewModel.shared.getCurrentUserId() ?? "")
                    gettingUserDetail()
                    
                }.onReceive(NotificationCenter.default.publisher(for: .settingRecordUpdated)) { _ in
                    gettingUserDetail()
                }
                
                if isReminderLoading{
                    Rectangle().fill(Color(.white)).opacity(0.8)
                }
                
                ActivityIndicatorView(text: "Loading", isLoading: $isReminderLoading)
                    .frame(height: 20)
                    .padding(.top, 15)
            }
        }
    }
    
    private func gettingUserDetail(){
        isLoading = true
        isReminderLoading = true
        DatabaseManager.shared.getUserDetail { userDetail, status in
            if status == 200{
                editReminderArr = [[String: Any]]()
                if let reminderData = userDetail[FireStoreChatConstant.userReminderArr] {
                    editReminderArr = reminderData as? [[String:Any]] ?? [[:]]
                    isLoading = false
                    settingsViewModel.setNotificationOnTimers(userDetail: editReminderArr) { triggerArr,triggerDateArr  in
                        isReminderLoading = false
                        CustomNotification.shared.callNotification(triggerArr: triggerArr)
                        settings.updateReminderNotificationSetting(triggerDateArr)
                        settings.deleteReminderNotification = [:]
                    }
                }
            }
        }
    }
    
    func backButton() -> some View {
        HStack() {
            Text("Setting").font(.setCustom(fontStyle: .title, fontWeight: .medium))
                .foregroundColor(Color("MainTextColor"))
            
        }.padding()
    }
    
    func nudgeSetting() -> some View {
        VStack{
            Text("Nudge Settings").font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                .foregroundColor(Color("MainTextColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            Text("if you feel that the alert is triggered too soon when you rise the hand to your face, add some delay here").font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                .foregroundColor(Color("TextFieldTextColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
        }
    }
    
    func reminderSetting() -> some View {
        VStack{
            Text("App reminders").font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                .foregroundColor(Color("MainTextColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            
            Text("We’ll send you a reminder to keep the app active. When do you prefer to receive it?").font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                .foregroundColor(Color("TextFieldTextColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            
            /*ActivityIndicatorView(text: "Loading...", isLoading: $isLoading)
             .frame(height: (isLoading ? 20 : 0))*/
            //.padding()
            
            editReminder()
            
            Button(action: {
                //self.showWeekdaysView = true
                introProgressTracker.introWeekDayArr = [Weekdays]()
                introProgressTracker.getReminderTime = 0.0
                homeRouter.navigate(to: .reminderView)
            }, label: {
                HStack {
                    Text("Add app reminder")
                        .font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                        .foregroundColor(Color("TextFieldTextColor"))
                        .padding(.leading, 16)
                    Spacer()
                    Image("rightArrow")
                        .padding(.trailing, 16)
                }.frame(minHeight: 50)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay{
                        RoundedRectangle(cornerRadius: 5, style: .circular).stroke(Color("BorderColor"), lineWidth: 0.8)
                    }
                    .padding(.horizontal, 24)
            }).padding(.bottom, 8)
        }
    }
    
    func editReminder() -> some View{
        
        VStack{
            ForEach(editReminderArr.indices, id: \.self) { index in
                let userDetail = editReminderArr[index]
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .frame(height: 70)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color("BorderColor"), lineWidth: 2)
                                
                            )
                        
                        HStack {
                            ZStack{
                                HStack{
                                    VStack(){
                                        HStack{
                                            let time : TimeInterval = userDetail[FireStoreChatConstant.userReminder] as? TimeInterval ?? 946715700
                                            Text(time.convertTimeIntervalToString())
                                                .font(.setCustom(fontStyle: .title, fontWeight: .medium))
                                                .foregroundColor(Color("TextFieldTextColor"))
                                            Spacer()
                                        }
                                        HStack{
                                            Text(userDetail[FireStoreChatConstant.userWeekendReminder] as? String ?? "")
                                                .font(.setCustom(fontStyle: .subheadline, fontWeight: .medium))
                                                .foregroundColor(Color("TextFieldTextColor"))
                                            Spacer()
                                        }
                                            
                                        
                                    }
                                    Spacer()
                                }
                                
                                Button(action: {
                                    UserDefaults.standard.set(true, forKey: "FromReminderEdit")
                                    introProgressTracker.introReminderData = editReminderArr[index]
                                    introProgressTracker.getReminderTime = userDetail[FireStoreChatConstant.userReminder] as? TimeInterval ?? 946715700
                                    var modelArr = [Weekdays]()
                                    let model = Weekdays(name: editReminderArr[index][FireStoreChatConstant.userWeekendReminder] as? String ?? "", isSelected: true)
                                    modelArr.append(model)
                                    introProgressTracker.introWeekDayArr = modelArr
                                    homeRouter.navigate(to: .reminderView)
                                }, label: {
                                    VStack(alignment: .leading){
                                        
                                        Text("")
                                            .padding(.leading, 4.0)
                                            .font(.setCustom(fontStyle: .title, fontWeight: .medium))
                                            .foregroundColor(Color("TextFieldTextColor"))
                                            .frame(maxWidth: .infinity)
                                            
                                        Text("")
                                            .font(.setCustom(fontStyle: .subheadline, fontWeight: .medium))
                                            .foregroundColor(Color("TextFieldTextColor"))
                                            .frame(maxWidth: .infinity)
                                        
                                    }
                                })
                            }
                            
                            
                        }.padding(.horizontal, 16).padding(.top,9)
                            .padding(.bottom,9)
                            .padding(.trailing, 60)
                                .padding(.leading, 10)
                        
                        HStack{
                            Toggle("", isOn: self.binding(for: index)).padding(.trailing, 10)
                                .toggleStyle(SwitchToggleStyle(tint: Color("TopFadeColor")))
                                .onAppear{
                                    reminderStatus = userDetail[FireStoreChatConstant.userReminderStatus] as? Bool ?? false
                                }
                        }
                        
                        /*if index != editReminderArr.count - 1 {
                            Rectangle()
                                .fill(Color("ButtonDisableColor"))
                                .frame(maxWidth: .infinity, maxHeight: 1)
                        }*/
                    }.padding(.horizontal, 24)
                }
            }
        }
        
        
        
        
        
        
        
        /*ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .frame(height: 70 * CGFloat(editReminderArr.count))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("BorderColor"), lineWidth: 2)
                    
                )
            VStack(alignment: .leading,spacing: 0) {
                ForEach(editReminderArr.indices, id: \.self) { index in
                    VStack(spacing: 0) {
                        
                        
                    }
                }
            }
        }.padding(.horizontal, 24)*/
    }
    
    private func binding(for index: Int) -> Binding<Bool> {
        
        Binding(
            get: {
                let userDetail = editReminderArr[index]
                let oldReminderStatus = userDetail[FireStoreChatConstant.userReminderStatus] as? Bool ?? false
                return oldReminderStatus
            },
            set: { newValue in
                
                let userDetail = editReminderArr[index]
                let oldReminderTime = userDetail[FireStoreChatConstant.userReminder] as? TimeInterval ?? 946715700
                let oldWeekendReminder = userDetail[FireStoreChatConstant.userWeekendReminder] as? String ?? ""
                
                CustomNotification.shared.cancelNotification(time: oldReminderTime.convertTimeIntervalToString(), weekend: oldWeekendReminder)
                
                settingsViewModel.getTimeReminder(timeReminderStr: oldReminderTime) { hour, minute in
                    settingsViewModel.getWeekendReminder(weekendReminderStr: oldWeekendReminder) { weekDay in
                        var userDetail = [String: Any]()
                        userDetail["Hour"] = hour
                        userDetail["Minute"] = minute
                        userDetail["WeekDay"] = weekDay
                        settings.deleteReminderNotification = userDetail
                    }
                }
               
                for indx in 0 ..< editReminderArr.count {
                    var detailDict : [String : Any] = editReminderArr[indx]
                    let updateReminderTime = detailDict[FireStoreChatConstant.userReminder]  as? TimeInterval ?? 946715700
                    let updateWeekendReminder = detailDict[FireStoreChatConstant.userWeekendReminder]  as? String ?? ""
                    if oldReminderTime.convertTimeIntervalToString() == updateReminderTime.convertTimeIntervalToString() && oldWeekendReminder == updateWeekendReminder {
                        detailDict[FireStoreChatConstant.userReminderStatus] = newValue
                        editReminderArr[indx] = detailDict
                        DatabaseManager.shared.updateReminderOnSwitchChange(userReminderArr: editReminderArr) { status in
                            if status == 200 {
                                gettingUserDetail()
                            }
                        }
                        break
                    }
                }
            }
        )
    }
    
    func sliderSetting() -> some View{
        
        VStack{
            
            /*SliderView(value: $sliderValue, thumbColor: UIColor(Color("TopFadeColor")))
             .accentColor(Color("TopFadeColor"))
             .frame(maxWidth: .infinity, alignment: .leading)
             .padding(.horizontal, 24)
             .padding(.bottom, 8)*/
            Slider(value: $settings.alertDelay, in: 0...5, step: 0.5)
                .onChange(of: settings.alertDelay) { newValue in
                    settings.updateAlertDelayDataToFB()
                    
                }
                .accentColor(Color("TopFadeColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            
            HStack{
                Text("Immediate").font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                    .foregroundColor(Color("MainTextColor"))
                Spacer()
                if settings.alertDelay != 0.0 && Int(settings.alertDelay) != 0{
                    Text(String(format: "After %.1f Sec", settings.alertDelay))
                        .font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                        .foregroundColor(Color("MainTextColor"))
                }
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            
        }.onChange(of: sliderValue) { newValue in
            sliderValue += 0.01
            print("Slider value changed to: \(sliderValue)")
            
        }.onAppear{
            DatabaseManager.shared.getUserDetail { userDetail, status in
                if status == 200{
                    UserDefaults.standard.set(true, forKey: SharedConstants.alertsOn)
                    settings.alertsOn = true
                    if let delay = userDetail[FireStoreChatConstant.userAlertDelayKey]{
                        UserDefaults.standard.set(delay, forKey: SharedConstants.alertDelayKey)
                        settings.alertDelay = delay as? Double ?? 0.0
                        
                    }else{
                        UserDefaults.standard.set(0, forKey: SharedConstants.alertDelayKey)
                        settings.alertDelay = 0.0
                    }
                }
            }
        }
    }
    
    func managedSetting()  -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("BackgroundColor"))
                .frame(height: 294)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("BackgroundColor"), lineWidth: 2)
                    
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            VStack{
                Text("The following settings are managed in the “settings” of your phone:").font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                    .foregroundColor(Color("MainTextColor"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.white))
                        .frame(height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("BackgroundColor"), lineWidth: 2)
                            
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 8)
                    
                    Text("Nudge intensity").font(.setCustom(fontStyle: .subheadline, fontWeight: .medium))
                        .foregroundColor(Color("MainTextColor"))
                        .padding(.bottom, 8)
                }
                
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.white))
                        .frame(height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("BackgroundColor"), lineWidth: 2)
                            
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 8)
                    
                    Text("Watch position and orientation").font(.setCustom(fontStyle: .subheadline, fontWeight: .medium))
                        .foregroundColor(Color("MainTextColor"))
                        .padding(.bottom, 8)
                }
                
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.white))
                        .frame(height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("BackgroundColor"), lineWidth: 2)
                            
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 8)
                    
                    Text("Nudge Sound").font(.setCustom(fontStyle: .subheadline, fontWeight: .medium))
                        .foregroundColor(Color("MainTextColor"))
                        .padding(.bottom, 8)
                }
                
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.white))
                        .frame(height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("BackgroundColor"), lineWidth: 2)
                            
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 8)
                    
                    Text("Sleeping time").font(.setCustom(fontStyle: .subheadline, fontWeight: .medium))
                        .foregroundColor(Color("MainTextColor"))
                        .padding(.bottom, 8)
                }
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
