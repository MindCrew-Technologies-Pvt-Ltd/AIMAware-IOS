//
//  ReminderUIView.swift
//  AImAware
//
//  Created by Suyog on 20/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct ReminderUIView: View {
    //@ObservedObject var viewModel = ViewModel()
    @State var chosenDate = Date()
    @State var reminderDate : TimeInterval = 946715700
    @State var weekArr = [Weekdays]()
    @State private var showWeekdaysView = false
    @State private var isCompleteAllFields = false
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    @Binding var weekDaysArray : [Weekdays]
    @State var showAlert = false
    @State var activityText = ""
    @State var isRectangleVisble = false
    @State private var isLoading = false
    @State var isCompleteAllData = false
    @State var isReminderDelete = false
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var homeRouter: NavigationHomeRouter
    @EnvironmentObject var sceneDelegate: SceneDelegate
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        ZStack{
            VStack() {
                if USER_DEFAULTS.value(forKey: LOGINTYPE) as? String ?? "" == "All Exist"{
                    HStack(spacing: 16) {
                        Button(action: {
                            UserDefaults.standard.set(false, forKey: "FromReminderEdit")
                            NotificationCenter.default.post(name: .settingRecordUpdated, object: nil)
                            homeRouter.navigateBack()
                        }, label: {
                            Image("back")
                        })
                        
                        Text("Set your reminder").font(.setCustom(fontStyle: .title, fontWeight: .medium)).multilineTextAlignment(.center)
                        Spacer()
                        
                        if UserDefaults.standard.bool(forKey: "FromReminderEdit") {
                            Button(action: {
                                isReminderDelete = true
                            }, label: {
                                Text("Delete").font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("DeleteButtonColor"))
                                
                            }).padding(.trailing, 20)
                                .alert("Are you sure you want to delete this reminder", isPresented: $isReminderDelete) {
                                    Button("Yes", role: .cancel) {
                                        DatabaseManager.shared.deleteReminder(userReminderArr: introProgressTracker.introReminderData) { status in
                                            if status == 200{
                                                AnalyticsHelper.logCreatedEvent(key: "reminder_deleted", value: SignUpCompleteViewModel.shared.getCurrentUserId() ?? "")
                                                homeRouter.navigateBack()
                                            }else{
                                                isCompleteAllData = true
                                            }
                                        }
                                    }
                                    Button("No", role: .destructive) {}
                                }
                        }
                        
                    }.padding(.leading, 24)
                }else{
                    Text("Set your reminder").font(.setCustom(fontStyle: .title, fontWeight: .medium))
                }
                
                Spacer()
                VStack {
                    
                    DatePicker("", selection: $chosenDate, displayedComponents: [.hourAndMinute])
                        .datePickerStyle(.wheel)
                        .background(Color.white)
                        .cornerRadius(15)
                        .padding(10)
                        .onAppear{
                            if introProgressTracker.getReminderTime == 0.0 {
                                chosenDate = Date()
                            }else{
                                let newDate : String = introProgressTracker.getReminderTime.convertTimeIntervalToString()
                                chosenDate = newDate.convertToDate() ?? Date()
                            }
                            
                            
                        }
                        .onChange(of: chosenDate) { newDate in
                            // Do something with the new selected date
                            introProgressTracker.getReminderTime = convertToTimestamp(date: chosenDate)// dateFormatter.string(from: chosenDate)
                        }
                    HStack {
                        Text("Repeat")
                            .font(.setCustom(fontStyle: .subheadline, fontWeight: .medium))
                            .padding(.horizontal,24)
                        Spacer()
                    }
                    
                    Button(action: {
                        if USER_DEFAULTS.value(forKey: LOGINTYPE) as? String ?? "" == "All Exist"{
                            homeRouter.navigate(to: .weekendView)
                        }else{
                            router.navigate(to: .weekendView)
                        }
                        
                    }, label: {
                        HStack {
                            Text((introProgressTracker.introWeekDayArr.count > 0) ? ((introProgressTracker.introWeekDayArr.count == 1) ? "\(introProgressTracker.introWeekDayArr.count) workday selected" : "\(introProgressTracker.introWeekDayArr.count) workdays selected") : "Tap for getting workdays")
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
                    })
                    
                    // Spacer(minLength: 170)
                    Spacer()
                    HStack(spacing: 16) {
                        
                        Button(action: {
                            reminderDate = convertToTimestamp(date: chosenDate)
                            //reminderDate = dateFormatter.string(from: chosenDate)
                            isCompleteAllFields = addValidation()
                            if !isCompleteAllFields{
                                showAlert = true
                            }else{
                                var weekendReminder = [String]()
                                for data in introProgressTracker.introWeekDayArr{
                                    weekendReminder.append(data.name ?? "")
                                }
                                let model = SignUpCompleteFlowModel(userReminder: reminderDate, userWeekendReminder: weekendReminder)
                                storeReminderData(weekendReminder: weekendReminder, model: model)
                                
                            }
                        }) {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                                .font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                                .padding()
                            //.padding(.bottom, 10)
                                .foregroundColor(.white)
                                .background(Color("MiddleFadeColor2"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white, lineWidth: 2)
                                    
                                )
                        }
                        //.padding(.bottom, 10)
                        .navigationBarBackButtonHidden(true)
                        .background(Color.blue) // If you have this
                        .cornerRadius(12)
                        .alert("Please select any workday", isPresented: $showAlert) {
                            Button("OK", role: .cancel) {}
                        }
                        .alert(FireStoreChatConstant.completeDataError, isPresented: $isCompleteAllData) {
                            Button("OK", role: .cancel) {}
                        }
                    }
                    .padding(.horizontal,24)
                    .padding(.bottom, 10)
                }
            }
            
            if isRectangleVisble{
                Rectangle().fill(Color(.white)).opacity(0.8)
            }
            
            ActivityIndicatorView(text: activityText, isLoading: $isLoading)
                .frame(height: 20)
                .padding(.top, 15)
        }
    }
    
    
    func addValidation() -> Bool {
        if ((reminderDate == 0.0) || introProgressTracker.introWeekDayArr.count == 0) {
            return false
            
        }
        return true
    }
    
    func storeReminderData(weekendReminder : [String], model: SignUpCompleteFlowModel){
        isLoading = true
        isRectangleVisble = true
        if UserDefaults.standard.bool(forKey: "FromReminderEdit") {
            UserDefaults.standard.set(false, forKey: "FromReminderEdit")
            activityText = "Updating..."
            DatabaseManager.shared.deleteReminder(userReminderArr: introProgressTracker.introReminderData) { status in
                if status == 200{
                    DatabaseManager.shared.getUserReminder(userId: SignUpCompleteViewModel.shared.getCurrentUserId() ?? "", model: model) { status in
                        if status == 200{
                            isLoading = false
                            isRectangleVisble = false
                            //viewModel.showDetails = true
                            AnalyticsHelper.logCreatedEvent(key: "reminder_updated", value: SignUpCompleteViewModel.shared.getCurrentUserId() ?? "")
                            NotificationCenter.default.post(name: .settingRecordUpdated, object: nil)
                            homeRouter.navigateBack()
                        }else{
                            isCompleteAllData = true
                        }
                    }
                }else{
                    isCompleteAllData = true
                }
            }
            
        }else{
            if USER_DEFAULTS.value(forKey: LOGINTYPE) as? String ?? "" == "All Exist"{
                activityText = "Updating..."
                DatabaseManager.shared.getUserReminder(userId: SignUpCompleteViewModel.shared.getCurrentUserId() ?? "", model: model) { status in
                    if status == 200{
                        isLoading = false
                        isRectangleVisble = false
                        AnalyticsHelper.logCreatedEvent(key: "reminder_created", value: SignUpCompleteViewModel.shared.getCurrentUserId() ?? "")
                        homeRouter.navigateBack()
                        NotificationCenter.default.post(name: .settingRecordUpdated, object: nil)
                    }else{
                        isCompleteAllData = true
                    }
                }
            }else{
                activityText = "Creating..."
                let model = SignUpCompleteFlowModel(userReminder: reminderDate,userComes: signUpTypeName.reminderSignup.rawValue, userWeekendReminder: weekendReminder)
                SignUpCompleteViewModel.shared.addSignUpCompleteData(signUpType: .reminderSignup, signupModel: model){ status in
                    if status {
                        isLoading = false
                        isRectangleVisble = false
                        AnalyticsHelper.logCreatedEvent(key: "reminder_created", value: SignUpCompleteViewModel.shared.getCurrentUserId() ?? "")
                        router.navigateToRoot()
                        USER_DEFAULTS.set("All Exist", forKey: LOGINTYPE)
                        introProgressTracker.isUserLoggedIn = true
                        introProgressTracker.isSavedDataToFB = true
                        introProgressTracker.introWeekDayArr = []
                        
                    }else{
                        isCompleteAllData = true
                    }
                }
            }
        }
    }
    
    func convertToTimestamp(date: Date) -> TimeInterval {
        print("date.timeIntervalSince1970 \(date.timeIntervalSince1970)")
        return date.timeIntervalSince1970
    }
    
}

#Preview {
    ReminderUIView(weekDaysArray: .constant([]))
}

import UIKit

/// screen react
extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
    static let safeAreaTopHCon = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first?.safeAreaInsets
}

extension String {
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: self)
    }
}



