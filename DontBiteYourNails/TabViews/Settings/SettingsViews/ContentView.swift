//
//  ContentView.swift
//  Dont2
//
//  Created by Sune Kristian Jakobsen on 04/03/2020.
//  Copyright © 2020 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI
import CoreData
import FirebaseAuth

struct ContentView: View {
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    let config = Config.shared
    @ObservedObject var remoteConfig = RemoteConfigHelper.shared
    @StateObject var router = NavigationRouter()
    @StateObject var homeRouter = NavigationHomeRouter()
    //@EnvironmentObject var viewModel: DayListViewModel
    var body: some View {
        if remoteConfig.hasFinished{
            if introProgressTracker.hasCompleteIntro || !config.includeIntroFlow {
                
                if introProgressTracker.isUserLoggedIn{
                    navigationHomeView()
                    
                }else{
                    if USER_DEFAULTS.value(forKey: LOGINTYPE) as? String ?? "" == "Logout"{
                        navigateToLoginPageView()
                    }else{
                        if USER_DEFAULTS.value(forKey: LOGINTYPE) as? String ?? "" == "All Exist"{
                            navigationHomeView()
                        }else if USER_DEFAULTS.value(forKey: LOGINTYPE) as? String ?? "" == "Reminder not exist"{
                            navigateToWelcomePageView()
                        }else {
                            navigationAllView()
                        }
                    }
                }
            }else{
                IntroductionFlowView()
            }
            
        }else{
            RemoteConfigView(remoteConfig: remoteConfig)
        }
    }
    
    func navigationAllView() -> some View {
        NavigationStack(path: $router.navPath) {
            
            if USER_DEFAULTS.bool(forKey: FROMSIGNUP) {
                let model : SignUpCompleteFlowModel = SignUpCompleteViewModel.shared.fetchDataAsLocally()
                
                switch model.userComes {
                    
                case signUpTypeName.createSignup.rawValue:
                    StatsView()
                        .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                            switch destination {
                            case .tutorialView:
                                TutorialView()
                            case .forgotView:
                                ForgotPasswordUIView()
                            case .loginView:
                                AuthenticationView()
                            case .signUpView:
                                SignUpUIView()
                            case .stateView:
                                StatsView()
                            case .habitView:
                                HabitView(habitSelect: "")
                            case .stepToFollowView:
                                StepsToFollowUIView()
                            case .finishView:
                                FinishUIView()
                            case .reminderView:
                                ReminderUIView(weekDaysArray: .constant([]))
                            case .weekendView:
                                ReminderWeekdaysUIView()
                            case .completeView:
                                MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                            }
                        }
                    
                case signUpTypeName.stateSignup.rawValue:
                    HabitView(habitSelect: "")
                        .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                            switch destination {
                            case .tutorialView:
                                TutorialView()
                            case .forgotView:
                                ForgotPasswordUIView()
                            case .loginView:
                                AuthenticationView()
                            case .signUpView:
                                SignUpUIView()
                            case .stateView:
                                StatsView()
                            case .habitView:
                                HabitView(habitSelect: "")
                            case .stepToFollowView:
                                StepsToFollowUIView()
                            case .finishView:
                                FinishUIView()
                            case .reminderView:
                                ReminderUIView(weekDaysArray: .constant([]))
                            case .weekendView:
                                ReminderWeekdaysUIView()
                            case .completeView:
                                MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                            }
                        }
                    
                case signUpTypeName.habitSignup.rawValue:
                    FinishUIView()
                        .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                            switch destination {
                            case .tutorialView:
                                TutorialView()
                            case .forgotView:
                                ForgotPasswordUIView()
                            case .loginView:
                                AuthenticationView()
                            case .signUpView:
                                SignUpUIView()
                            case .stateView:
                                StatsView()
                            case .habitView:
                                HabitView(habitSelect: "")
                            case .stepToFollowView:
                                StepsToFollowUIView()
                            case .finishView:
                                FinishUIView()
                            case .reminderView:
                                ReminderUIView(weekDaysArray: .constant([]))
                            case .weekendView:
                                ReminderWeekdaysUIView()
                            case .completeView:
                                MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                            }
                        }
                    
                case signUpTypeName.finishSignup.rawValue:
                    ReminderUIView(weekDaysArray: .constant([]))
                        .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                            switch destination {
                            case .tutorialView:
                                TutorialView()
                            case .forgotView:
                                ForgotPasswordUIView()
                            case .loginView:
                                AuthenticationView()
                            case .signUpView:
                                SignUpUIView()
                            case .stateView:
                                StatsView()
                            case .habitView:
                                HabitView(habitSelect: "")
                            case .stepToFollowView:
                                StepsToFollowUIView()
                            case .finishView:
                                FinishUIView()
                            case .reminderView:
                                ReminderUIView(weekDaysArray: .constant([]))
                            case .weekendView:
                                ReminderWeekdaysUIView()
                            case .completeView:
                                MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                            }
                        }
                    
                case signUpTypeName.reminderSignup.rawValue:
                    navigationHomeView()
                    
                default:
                    WelcomePageView()
                        .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                            switch destination {
                            case .tutorialView:
                                TutorialView()
                            case .forgotView:
                                ForgotPasswordUIView()
                            case .loginView:
                                AuthenticationView()
                            case .signUpView:
                                SignUpUIView()
                            case .stateView:
                                StatsView()
                            case .habitView:
                                HabitView(habitSelect: "")
                            case .stepToFollowView:
                                StepsToFollowUIView()
                            case .finishView:
                                FinishUIView()
                            case .reminderView:
                                ReminderUIView(weekDaysArray: .constant([]))
                            case .weekendView:
                                ReminderWeekdaysUIView()
                            case .completeView:
                                MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                            }
                        }
                }
                
            }else{
                if let uID = USER_DEFAULTS.value(forKey: USERID) as? String, Auth.auth().currentUser?.uid == uID{
                    
                    let model : SignUpCompleteFlowModel = SignUpCompleteViewModel.shared.fetchDataAsLocally()
                    
                    switch model.userComes {
                        
                    case signUpTypeName.createSignup.rawValue:
                        StatsView()
                            .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                                switch destination {
                                case .tutorialView:
                                    TutorialView()
                                case .forgotView:
                                    ForgotPasswordUIView()
                                case .loginView:
                                    AuthenticationView()
                                case .signUpView:
                                    SignUpUIView()
                                case .stateView:
                                    StatsView()
                                case .habitView:
                                    HabitView(habitSelect: "")
                                case .stepToFollowView:
                                    StepsToFollowUIView()
                                case .finishView:
                                    FinishUIView()
                                case .reminderView:
                                    ReminderUIView(weekDaysArray: .constant([]))
                                case .weekendView:
                                    ReminderWeekdaysUIView()
                                case .completeView:
                                    MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                                }
                            }
                        
                    case signUpTypeName.stateSignup.rawValue:
                        HabitView(habitSelect: "")
                            .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                                switch destination {
                                case .tutorialView:
                                    TutorialView()
                                case .forgotView:
                                    ForgotPasswordUIView()
                                case .loginView:
                                    AuthenticationView()
                                case .signUpView:
                                    SignUpUIView()
                                case .stateView:
                                    StatsView()
                                case .habitView:
                                    HabitView(habitSelect: "")
                                case .stepToFollowView:
                                    StepsToFollowUIView()
                                case .finishView:
                                    FinishUIView()
                                case .reminderView:
                                    ReminderUIView(weekDaysArray: .constant([]))
                                case .weekendView:
                                    ReminderWeekdaysUIView()
                                case .completeView:
                                    MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                                }
                            }
                        
                    case signUpTypeName.habitSignup.rawValue:
                        FinishUIView()
                            .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                                switch destination {
                                case .tutorialView:
                                    TutorialView()
                                case .forgotView:
                                    ForgotPasswordUIView()
                                case .loginView:
                                    AuthenticationView()
                                case .signUpView:
                                    SignUpUIView()
                                case .stateView:
                                    StatsView()
                                case .habitView:
                                    HabitView(habitSelect: "")
                                case .stepToFollowView:
                                    StepsToFollowUIView()
                                case .finishView:
                                    FinishUIView()
                                case .reminderView:
                                    ReminderUIView(weekDaysArray: .constant([]))
                                case .weekendView:
                                    ReminderWeekdaysUIView()
                                case .completeView:
                                    MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                                }
                            }
                        
                    case signUpTypeName.finishSignup.rawValue:
                        ReminderUIView(weekDaysArray: .constant([]))
                            .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                                switch destination {
                                case .tutorialView:
                                    TutorialView()
                                case .forgotView:
                                    ForgotPasswordUIView()
                                case .loginView:
                                    AuthenticationView()
                                case .signUpView:
                                    SignUpUIView()
                                case .stateView:
                                    StatsView()
                                case .habitView:
                                    HabitView(habitSelect: "")
                                case .stepToFollowView:
                                    StepsToFollowUIView()
                                case .finishView:
                                    FinishUIView()
                                case .reminderView:
                                    ReminderUIView(weekDaysArray: .constant([]))
                                case .weekendView:
                                    ReminderWeekdaysUIView()
                                case .completeView:
                                    MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                                }
                            }
                        
                    case signUpTypeName.reminderSignup.rawValue:
                        navigationHomeView()
                        
                    default:
                        WelcomePageView()
                            .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                                switch destination {
                                case .tutorialView:
                                    TutorialView()
                                case .forgotView:
                                    ForgotPasswordUIView()
                                case .loginView:
                                    AuthenticationView()
                                case .signUpView:
                                    SignUpUIView()
                                case .stateView:
                                    StatsView()
                                case .habitView:
                                    HabitView(habitSelect: "")
                                case .stepToFollowView:
                                    StepsToFollowUIView()
                                case .finishView:
                                    FinishUIView()
                                case .reminderView:
                                    ReminderUIView(weekDaysArray: .constant([]))
                                case .weekendView:
                                    ReminderWeekdaysUIView()
                                case .completeView:
                                    MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                                }
                            }
                    }
                    
                }else{
                
                    WelcomePageView()
                        .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                            switch destination {
                            case .tutorialView:
                                TutorialView()
                            case .forgotView:
                                ForgotPasswordUIView()
                            case .loginView:
                                AuthenticationView()
                            case .signUpView:
                                SignUpUIView()
                            case .stateView:
                                StatsView()
                            case .habitView:
                                HabitView(habitSelect: "")
                            case .stepToFollowView:
                                StepsToFollowUIView()
                            case .finishView:
                                FinishUIView()
                            case .reminderView:
                                ReminderUIView(weekDaysArray: .constant([]))
                            case .weekendView:
                                ReminderWeekdaysUIView()
                            case .completeView:
                                MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                            }
                        }
                    
                }
            }
            
        }
        .environmentObject(router)
    }
    
    func navigateToWelcomePageView() -> some View {
        NavigationStack(path: $router.navPath) {
            
            if USER_DEFAULTS.bool(forKey: FROMSIGNUP) {
                let model : SignUpCompleteFlowModel = SignUpCompleteViewModel.shared.fetchDataAsLocally()
                
                switch model.userComes {
                    
                case signUpTypeName.createSignup.rawValue:
                    StatsView()
                        .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                            switch destination {
                            case .tutorialView:
                                TutorialView()
                            case .forgotView:
                                ForgotPasswordUIView()
                            case .loginView:
                                AuthenticationView()
                            case .signUpView:
                                SignUpUIView()
                            case .stateView:
                                StatsView()
                            case .habitView:
                                HabitView(habitSelect: "")
                            case .stepToFollowView:
                                StepsToFollowUIView()
                            case .finishView:
                                FinishUIView()
                            case .reminderView:
                                ReminderUIView(weekDaysArray: .constant([]))
                            case .weekendView:
                                ReminderWeekdaysUIView()
                            case .completeView:
                                MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                            }
                        }
                    
                case signUpTypeName.stateSignup.rawValue:
                    HabitView(habitSelect: "")
                        .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                            switch destination {
                            case .tutorialView:
                                TutorialView()
                            case .forgotView:
                                ForgotPasswordUIView()
                            case .loginView:
                                AuthenticationView()
                            case .signUpView:
                                SignUpUIView()
                            case .stateView:
                                StatsView()
                            case .habitView:
                                HabitView(habitSelect: "")
                            case .stepToFollowView:
                                StepsToFollowUIView()
                            case .finishView:
                                FinishUIView()
                            case .reminderView:
                                ReminderUIView(weekDaysArray: .constant([]))
                            case .weekendView:
                                ReminderWeekdaysUIView()
                            case .completeView:
                                MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                            }
                        }
                    
                case signUpTypeName.habitSignup.rawValue:
                    FinishUIView()
                        .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                            switch destination {
                            case .tutorialView:
                                TutorialView()
                            case .forgotView:
                                ForgotPasswordUIView()
                            case .loginView:
                                AuthenticationView()
                            case .signUpView:
                                SignUpUIView()
                            case .stateView:
                                StatsView()
                            case .habitView:
                                HabitView(habitSelect: "")
                            case .stepToFollowView:
                                StepsToFollowUIView()
                            case .finishView:
                                FinishUIView()
                            case .reminderView:
                                ReminderUIView(weekDaysArray: .constant([]))
                            case .weekendView:
                                ReminderWeekdaysUIView()
                            case .completeView:
                                MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                            }
                        }
                    
                case signUpTypeName.finishSignup.rawValue:
                    ReminderUIView(weekDaysArray: .constant([]))
                        .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                            switch destination {
                            case .tutorialView:
                                TutorialView()
                            case .forgotView:
                                ForgotPasswordUIView()
                            case .loginView:
                                AuthenticationView()
                            case .signUpView:
                                SignUpUIView()
                            case .stateView:
                                StatsView()
                            case .habitView:
                                HabitView(habitSelect: "")
                            case .stepToFollowView:
                                StepsToFollowUIView()
                            case .finishView:
                                FinishUIView()
                            case .reminderView:
                                ReminderUIView(weekDaysArray: .constant([]))
                            case .weekendView:
                                ReminderWeekdaysUIView()
                            case .completeView:
                                MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                            }
                        }
                    
                case signUpTypeName.reminderSignup.rawValue:
                    navigationHomeView()
                    
                default:
                    WelcomePageView()
                        .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                            switch destination {
                            case .tutorialView:
                                TutorialView()
                            case .forgotView:
                                ForgotPasswordUIView()
                            case .loginView:
                                AuthenticationView()
                            case .signUpView:
                                SignUpUIView()
                            case .stateView:
                                StatsView()
                            case .habitView:
                                HabitView(habitSelect: "")
                            case .stepToFollowView:
                                StepsToFollowUIView()
                            case .finishView:
                                FinishUIView()
                            case .reminderView:
                                ReminderUIView(weekDaysArray: .constant([]))
                            case .weekendView:
                                ReminderWeekdaysUIView()
                            case .completeView:
                                MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                            }
                        }
                }
                
            }else{
                if let uID = USER_DEFAULTS.value(forKey: USERID) as? String, Auth.auth().currentUser?.uid == uID{
                    
                    let model : SignUpCompleteFlowModel = SignUpCompleteViewModel.shared.fetchDataAsLocally()
                    
                    switch model.userComes {
                        
                    case signUpTypeName.createSignup.rawValue:
                        StatsView()
                            .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                                switch destination {
                                case .tutorialView:
                                    TutorialView()
                                case .forgotView:
                                    ForgotPasswordUIView()
                                case .loginView:
                                    AuthenticationView()
                                case .signUpView:
                                    SignUpUIView()
                                case .stateView:
                                    StatsView()
                                case .habitView:
                                    HabitView(habitSelect: "")
                                case .stepToFollowView:
                                    StepsToFollowUIView()
                                case .finishView:
                                    FinishUIView()
                                case .reminderView:
                                    ReminderUIView(weekDaysArray: .constant([]))
                                case .weekendView:
                                    ReminderWeekdaysUIView()
                                case .completeView:
                                    MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                                }
                            }
                        
                    case signUpTypeName.stateSignup.rawValue:
                        HabitView(habitSelect: "")
                            .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                                switch destination {
                                case .tutorialView:
                                    TutorialView()
                                case .forgotView:
                                    ForgotPasswordUIView()
                                case .loginView:
                                    AuthenticationView()
                                case .signUpView:
                                    SignUpUIView()
                                case .stateView:
                                    StatsView()
                                case .habitView:
                                    HabitView(habitSelect: "")
                                case .stepToFollowView:
                                    StepsToFollowUIView()
                                case .finishView:
                                    FinishUIView()
                                case .reminderView:
                                    ReminderUIView(weekDaysArray: .constant([]))
                                case .weekendView:
                                    ReminderWeekdaysUIView()
                                case .completeView:
                                    MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                                }
                            }
                        
                    case signUpTypeName.habitSignup.rawValue:
                        FinishUIView()
                            .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                                switch destination {
                                case .tutorialView:
                                    TutorialView()
                                case .forgotView:
                                    ForgotPasswordUIView()
                                case .loginView:
                                    AuthenticationView()
                                case .signUpView:
                                    SignUpUIView()
                                case .stateView:
                                    StatsView()
                                case .habitView:
                                    HabitView(habitSelect: "")
                                case .stepToFollowView:
                                    StepsToFollowUIView()
                                case .finishView:
                                    FinishUIView()
                                case .reminderView:
                                    ReminderUIView(weekDaysArray: .constant([]))
                                case .weekendView:
                                    ReminderWeekdaysUIView()
                                case .completeView:
                                    MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                                }
                            }
                        
                    case signUpTypeName.finishSignup.rawValue:
                        ReminderUIView(weekDaysArray: .constant([]))
                            .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                                switch destination {
                                case .tutorialView:
                                    TutorialView()
                                case .forgotView:
                                    ForgotPasswordUIView()
                                case .loginView:
                                    AuthenticationView()
                                case .signUpView:
                                    SignUpUIView()
                                case .stateView:
                                    StatsView()
                                case .habitView:
                                    HabitView(habitSelect: "")
                                case .stepToFollowView:
                                    StepsToFollowUIView()
                                case .finishView:
                                    FinishUIView()
                                case .reminderView:
                                    ReminderUIView(weekDaysArray: .constant([]))
                                case .weekendView:
                                    ReminderWeekdaysUIView()
                                case .completeView:
                                    MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                                }
                            }
                        
                    case signUpTypeName.reminderSignup.rawValue:
                        navigationHomeView()
                        
                    default:
                        WelcomePageView()
                            .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                                switch destination {
                                case .tutorialView:
                                    TutorialView()
                                case .forgotView:
                                    ForgotPasswordUIView()
                                case .loginView:
                                    AuthenticationView()
                                case .signUpView:
                                    SignUpUIView()
                                case .stateView:
                                    StatsView()
                                case .habitView:
                                    HabitView(habitSelect: "")
                                case .stepToFollowView:
                                    StepsToFollowUIView()
                                case .finishView:
                                    FinishUIView()
                                case .reminderView:
                                    ReminderUIView(weekDaysArray: .constant([]))
                                case .weekendView:
                                    ReminderWeekdaysUIView()
                                case .completeView:
                                    MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                                }
                            }
                    }
                    
                }else{
                
                    WelcomePageView()
                        .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                            switch destination {
                            case .tutorialView:
                                TutorialView()
                            case .forgotView:
                                ForgotPasswordUIView()
                            case .loginView:
                                AuthenticationView()
                            case .signUpView:
                                SignUpUIView()
                            case .stateView:
                                StatsView()
                            case .habitView:
                                HabitView(habitSelect: "")
                            case .stepToFollowView:
                                StepsToFollowUIView()
                            case .finishView:
                                FinishUIView()
                            case .reminderView:
                                ReminderUIView(weekDaysArray: .constant([]))
                            case .weekendView:
                                ReminderWeekdaysUIView()
                            case .completeView:
                                MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                            }
                        }
                    
                }
            }
            
        }
        .environmentObject(router)
    }
    
    func navigateToLoginPageView() -> some View {
        
        NavigationStack(path: $router.navPath) {
            AuthenticationView()
                .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                    switch destination {
                    case .tutorialView:
                        TutorialView()
                    case .forgotView:
                        ForgotPasswordUIView()
                    case .loginView:
                        AuthenticationView()
                    case .signUpView:
                        SignUpUIView()
                    case .stateView:
                        StatsView()
                    case .habitView:
                        HabitView(habitSelect: "")
                    case .stepToFollowView:
                        StepsToFollowUIView()
                    case .finishView:
                        FinishUIView()
                    case .reminderView:
                        ReminderUIView(weekDaysArray: .constant([]))
                    case .weekendView:
                        ReminderWeekdaysUIView()
                    case .completeView:
                        MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                    }
                }
        }
        .environmentObject(router)
    }
    
    func navigationHomeView() -> some View {
        NavigationStack(path: $homeRouter.navHomePath) {
            MultiTabView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                .navigationDestination(for: NavigationHomeRouter.HomeDestination.self) { destination in
                    switch destination {
                    case .settingView:
                        SettingsView()
                    case .reminderView:
                        ReminderUIView(weekDaysArray: .constant([]))
                    case .weekendView:
                        ReminderWeekdaysUIView()
                    }
                }
        }
        .environmentObject(homeRouter)
        .alert("Thanks for complete signing up. Welcome to our app.", isPresented: $introProgressTracker.isSavedDataToFB) {
            Button("OK", role: .cancel) {}
        }
    }
}



struct MultiTabView: View {
    
    let config = Config.shared
    @State var selection = 0
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        TabView(selection: $selection) {
            DashboardView().environmentObject(DashboardViewModel()).tabItem {
                        if selection == 0 {
                            Image("Selectedhome")
                        } else {
                            Image("home")
                        }
                        Text("Home")
                    }.tag(0)
            
            StatisticsView().environmentObject(DayListViewModel()).tabItem {
                        if selection == 1 {
                            Image("SelectedStates")
                        } else {
                            Image("States")
                        }
                        Text("Statistics")
                    }.tag(1)
            
            /*HistoryView().environmentObject(DayListViewModel()).tabItem {
                        if selection == 2 {
                            Image("SelectedStates")
                        } else {
                            Image("States")
                        }
                        Text("History")
                    }.tag(2)*/
            
            if (config.includeGraphView) {
                GraphView().tabItem {
                    Label("Graphs", systemImage: "chart.line.uptrend.xyaxis")
                }
            }
                                
            SettingsView().tabItem {
                        if selection == 2 {
                            Image("SelectedSetting")
                        } else {
                            Image("Setting")
                        }
                        Text("Settings")
                    }.tag(2)
            
            ProfileView().tabItem {
                        if selection == 3 {
                            Image("SelectedProfile")
                        } else {
                            Image("Profile")
                        }
                        Text("Profile")
                    }.tag(3)
            
            if (config.enableDataCollectionSessions) {
                DataCollectionView().tabItem {
                    Label("Training Collection", systemImage: "pencil.and.ellipsis.rectangle")
                }
                
                /*FAQView().tabItem {
                 Label("FAQ", systemImage: "questionmark")
                 }*/
            }
                    
                    
                }.environment(\.colorScheme, .light)
            .accentColor(Color("TopFadeColor"))

//        TabView {
//            
//            DashboardView()
//                .environmentObject(DashboardViewModel())
//                .tabItem {
//                    Label("Home", systemImage: "house")
//                }
//            
//            HistoryView()
//                .environmentObject(DayListViewModel())
//                .accentColor(Color.white)//arrow back should be white
//                .tabItem {
//                    Label("History", systemImage: "calendar")
//                }
//            
//            
//            if (config.includeGraphView) {
//                GraphView().tabItem {
//                    Label("Graphs", systemImage: "chart.line.uptrend.xyaxis")
//                }
//            }
//            
//            SettingsView().tabItem {
//                Label("Settings", systemImage: "gear")
//            }
//            
//            
//            if (config.enableDataCollectionSessions) {
//                DataCollectionView().tabItem {
//                    Label("Training Collection", systemImage: "pencil.and.ellipsis.rectangle")
//                }
//                
//                /*FAQView().tabItem {
//                 Label("FAQ", systemImage: "questionmark")
//                 }*/
//            }
//        }.environment(\.colorScheme, .light)
//            .accentColor(Color("TopFadeColor"))// changed selected color in tab view, but also arrow back in nagivation view. To prevent this, accentColor is set to white when using nagivation view
        
    }
}

struct HistoryView: View {
    // @EnvironmentObject var coreDataManager: CoreDataManager
    @Environment(\.managedObjectContext) private var viewContext
    
    
    
    var body: some View {
        
        //     List {
        if #available(iOS 16.0, *) {
            //NavigationStack {
                DaysListView().environmentObject(DayListViewModel()).navigationBarTitle("Active days").navigationBarHidden(false)
            //}
        } else {
            //NavigationView {
                DaysListView().environmentObject(DayListViewModel()).navigationBarTitle("Active days").navigationBarHidden(false)
            //}
        }
    }
}



struct FAQView: View {
    var body: some View {
        VStack{
            Text("FAQ").font(.subheadline)
            List(faqData) { element in
                FAQElementView(element: element)
            }
        }
    }
}

struct RemoteConfigView: View {
    var remoteConfig: RemoteConfigHelper
    
    var body: some View {
        ZStack{
            Color("BackgroundColor")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .onAppear {
                    Task {
                        try await remoteConfig.startFetching()
                    }
                }
            
            ActivityIndicatorView(text: "Fetching Config...", isLoading: .constant(true))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
