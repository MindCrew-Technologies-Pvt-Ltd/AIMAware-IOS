//
//  ProfileView.swift
//  AImAware
//
//  Created by Suyog on 06/05/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var settings = PhoneSettings.shared
    let config = Config.shared
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    //@ObservedObject var recordingService = PhoneRecordingService.shared
    
    let eventService = EventService.shared
    @State private var showingDeleteAccountAlert = false
    @State private var showingLogoutAlert = false
    @State private var showingAlert = false
    @State private var errorString: String = ""
    @EnvironmentObject var router: NavigationRouter
    @StateObject var settingsViewModel = SettingsViewModel()
    //@State private var selectedSessionType: SessionType = SessionType.normalUse
    //@State var lastTap : Date?
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView{
                VStack(alignment: .leading) {
                    Text("Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 16) // Adjust as needed
                        .padding(.leading, 16) // Adjust to match the default navigation bar title's padding
                    
                    
                    GeneralNudgeSettingsView()
                    
                    
                    if (config.showDeveloperSettingsOptions) {
                        /*  HStack{
                         Text("Developer mode:")
                         .frame(width: 180, alignment: .leading)
                         Spacer()
                         Toggle("", isOn: $settings.developerSettings)
                         .labelsHidden()
                         }*/
                        
                        Group{
                            
                            Text("Developer Settings")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.top, 8)
                                .padding(.leading, 16)
                            
                            HStack{
                                Text("Record full watch session:")
                                    .frame(width: 180, alignment: .leading)
                                Spacer()
                                Toggle("", isOn: $settings.recordFullSession)
                                    .labelsHidden()
                                //.disabled(!isDeveloperSettingsEnabled())
                            }
                            
                            Spacer()
                            HStack{
                                Text("Alerts on:")
                                    .frame(width: 180, alignment: .leading)
                                Spacer()
                                Toggle("", isOn: $settings.alertsOn)
                                    .labelsHidden()
                                //.disabled(!isDeveloperSettingsEnabled())
                            }
                            Spacer()
                            HStack{
                                Text("Create secondary (sensitive) alert:")
                                    .frame(width: 180, alignment: .leading)
                                Spacer()
                                Toggle("", isOn: $settings.includeSecondaryAlert)
                                    .labelsHidden()
                                //.disabled(!isDeveloperSettingsEnabled())
                            }
                            Spacer()
                            if (settings.alertsOn || settings.includeSecondaryAlert) {
                                HStack {
                                    Text("Delay for recording minor movements: \(settings.observationDelay, specifier: "%.2f")")
                                        .frame(width: 180, alignment: .leading)
                                    Spacer()
                                    Slider(value: $settings.observationDelay, in: 0...10, step: 0.25)
                                    //.disabled(!isDeveloperSettingsEnabled())
                                }
                                Spacer()
                            }
                            /*
                             HStack{
                             Text("Record timestamp:")
                             .frame(width: 180, alignment: .leading)
                             Spacer()
                             Button(action: {
                             self.buttonTapped()
                             }) {
                             Text("Now!")
                             .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                             .background(Color.blue)
                             .foregroundColor(.white)
                             .cornerRadius(8)
                             }
                             }
                             Text("Last tap: \(lastTap?.formatted(date: .omitted, time: .standard) ?? "never")")
                             
                             /*         HStack {
                              Text("Autorecord phone during watch sessions")
                              Spacer()
                              Toggle("", isOn: $settings.autoRecord)
                              .labelsHidden()
                              }*/ // abandonned to keep session management simple
                             
                             */
                            /*
                             HStack {
                             Text("Record phone movements")
                             Spacer()
                             Button(action: {
                             if recordingService.isRecording {
                             recordingService.stopTimer()
                             } else {
                             recordingService.startTimer()
                             }
                             }) {
                             Text(recordingService.isRecording ? "Stop" : "Start")
                             .padding()
                             .background(recordingService.isRecording ? Color.blue : Color.red)
                             .foregroundColor(.white)
                             .cornerRadius(8)
                             }
                             }*/
                            
                        }.disabled(!isDeveloperSettingsEnabled())
                            .opacity(isDeveloperSettingsEnabled() ? 1 : 0.5)
                    }
                    
                    Group{
                        if (settings.alertsOn && config.showDeveloperSettingsOptions) {
                            Spacer()
                            Text("Set alerts")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.top, 8)
                                .padding(.leading, 16)
                            Spacer()
                            HStack{
                                Text("Use specific alerts:")
                                    .frame(width: 180, alignment: .leading)
                                Spacer()
                                Toggle("", isOn: $settings.useSpecificAlerts)
                                    .labelsHidden()
                            }
                            
                            Spacer()
                            
                            if (settings.useSpecificAlerts) {
                                VStack{
                                    let specificAreas: [String] = Array(SpecificArea.allValues.dropFirst())
                                    
                                    ForEach(specificAreas, id: \.self) { specificAreaString in
                                        HStack {
                                            Text(specificAreaString)
                                                .frame(width: 100, alignment: .leading)
                                            
                                            
                                            Slider(value: self.getAreaSensitivity(for: specificAreaString), in: 0.0...10.0)
                                            
                                            Text(String(format: "%.2f", self.getAreaSensitivity(for: specificAreaString).wrappedValue))
                                                .frame(width: 50, alignment: .trailing)
                                        }
                                    }
                                }
                            }
                        }
                    }.disabled(!isSpecificAlertsEnabled())
                        .opacity(isSpecificAlertsEnabled() ? 1 : 0.5)
                    
                    // Algorithm version?
                    // Add settings for track direction in a different view
                    
                    Spacer()
                    
                    PrivacySettingsView()
                    Spacer()
                    /*
                     WantToWorkOnSettingsView()
                     */
                    
                    if (config.makeIntroflowRestartable) {
                        Spacer()
                        HStack(alignment: .center) {
                            Spacer()
                            Button(action: {
                                introProgressTracker.currentIntroStep = IntroductionStep.welcome
                                introProgressTracker.hasCompleteIntro = false
                            }) {
                                Text("Restart intro flow!")
                                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .padding()
            //.background(Color("BackgroundColor"))
            
            PrimaryButtonView(text: "Delete Account", systemImage: "trash.fill") {
                //                isLoading = true
                showingDeleteAccountAlert = true
            }
            .alert("Are you sure you want to permanently delete your account?\nThis action can't be undone.", isPresented: $showingDeleteAccountAlert) {
                Button("Yes", role: .cancel) {
                    settingsViewModel.deleteUserAccount { isUserDeleted, errorStr in
                        if isUserDeleted{
                            UserDefaults.standard.set(0, forKey: SharedConstants.alertDelayKey)
                            USER_DEFAULTS.set("Logout", forKey: LOGINTYPE)
                            cancelNotifications()
                            SignUpCompleteViewModel.shared.removeAllKeys()
                            introProgressTracker.isUserLoggedIn = false
                            
                        }else{
                            errorString = errorStr ?? ""
                            showingAlert = true
                        }
                    }
                    
                }
                Button("No", role: .destructive) {}
            }
            .alert(errorString, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {}
            }
            
            PrimaryButtonView(text: "Logout", systemImage: "arrow.left") {
                showingLogoutAlert = true
            }
            .padding(.vertical, 24)
            .alert("Are you sure you want to logout?", isPresented: $showingLogoutAlert) {
                Button("Yes", role: .cancel) {
                    settingsViewModel.logoutUser { isLoggedOut, errorStr in
                        if isLoggedOut{
                            UserDefaults.standard.set(0, forKey: SharedConstants.alertDelayKey)
                            USER_DEFAULTS.set("Logout", forKey: LOGINTYPE)
                            cancelNotifications()
                            SignUpCompleteViewModel.shared.removeAllKeys()
                            introProgressTracker.isUserLoggedIn = false
                        }else{
                            errorString = errorStr ?? ""
                            showingAlert = true
                        }
                    }
                    
                }
                Button("No", role: .destructive) {}
            }
            .alert(errorString, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }
    
    fileprivate func isDeveloperSettingsEnabled() -> Bool {
        return settings.selectedSessionType == .developerSettings
    }
    
    fileprivate func isSpecificAlertsEnabled() -> Bool {
        return [.developerSettings, .normalUse].contains(settings.selectedSessionType)
    }
    
    func cancelNotifications(){
        DatabaseManager.shared.getUserDetail { userData, status in
            if status == 200{
                if let reminderData = userData[FireStoreChatConstant.userReminderArr] {
                    let reminderArr = reminderData as? [[String:Any]] ?? [[:]]
                    for userDetail in reminderArr {
                        let oldReminderTime = userDetail[FireStoreChatConstant.userReminder] as? String ?? ""
                        let oldWeekendReminder = userDetail[FireStoreChatConstant.userWeekendReminder] as? String ?? ""
                        CustomNotification.shared.cancelNotification(time: oldReminderTime, weekend: oldWeekendReminder)
                        /*settingsViewModel.getTimeReminder(timeReminderStr: oldReminderTime) { hour, minute in
                            settingsViewModel.getWeekendReminder(weekendReminderStr: oldWeekendReminder) { weekDay in
                                var userDetail = [String: Any]()
                                userDetail["Hour"] = hour
                                userDetail["Minute"] = minute
                                userDetail["WeekDay"] = weekDay
                                settings.deleteReminderNotification = userDetail
                            }
                        }*/
                    }
                }
            }
        }
    }
    
    func getAreaSensitivity(for area: String) -> Binding<Double> {
        let binding = Binding<Double>(
            get: {
                self.settings.areaSensitivities[area, default: 0.0]
            },
            set: { newValue in
                self.settings.updateAreaSensitivity(for: area, value: newValue)
            }
        )
        return binding
    }
    
    /*func buttonTapped() {
     print("Button was tapped!")
     self.lastTap = Date()
     _ = eventService.recordEvent(type: SharedConstants.tap)
     }*/
}

#Preview {
    ProfileView()
}
