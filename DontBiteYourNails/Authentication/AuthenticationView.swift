//
//  AuthenticationView.swift
//  AImAware
//
//  Created by Maulik Bhuptani on 20/02/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct AuthenticationView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @State private var showingAlert = false
    @State private var errorString: String = ""
    @State private var isValidData: Bool = false
    @State private var isValidDataString: String = ""
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    @State private var isLoading = false
    @State private var goToSignUpPage = false
    @State private var activityText: String = ""
    @State private var showEmailPleaseCompleteText: Bool = false
    @State private var showPasswordPleaseCompleteText: Bool = false
    @State private var usageDataImage: String = "checkmark.square.fill"
    @State var isSheetPresented = false
    @State var isRectangleVisble = false
    @State var checkBoxSelected = false
    @State var isShowForgotAlert = false
    @State var isCompleteAllData = false
    @ObservedObject var settings = PhoneSettings.shared
    @StateObject var settingsViewModel = SettingsViewModel()
    @EnvironmentObject var router: NavigationRouter
    var body: some View {
        VStack(spacing: 0) {
            ZStack{
                ScrollView {
                    VStack(spacing: 0){
                        
                        Spacer(minLength: 20)
                        Text("Welcome back").frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 24)
                            .font(.setCustom(fontStyle: .title, fontWeight: .medium))
                            .foregroundColor(Color("MainTextColor"))
                        Spacer(minLength: 17)
                        
                        CustomTextFieldView(placeHolderLabel: "Enter your email", topPlaceHolderLabel: "Email", text: $email, showPleaseCompleteText: $showEmailPleaseCompleteText, isFocused: $isEmailFocused, returnKeyType: .next, keyboardType: .emailAddress) {
                            isEmailFocused = false
                            isPasswordFocused = true
                        }
                        
                        SecurePassTextFieldView(placeHolderLabel: "Type here your password", topPlaceHolderLabel: "Password", text: $password, showPleaseCompleteText: $showPasswordPleaseCompleteText, isFocused: $isPasswordFocused) {
                            isPasswordFocused = false
                            print("asdasdsda")
                        }
                        
                        HStack{
                            Spacer()
                            SecondaryButtonView(text: "Forgotten your password?") {
                                /*isEmailFocused = false
                                isPasswordFocused = false
                                
                                if email.isEmpty{
                                    isShowForgotAlert = true
                                    return
                                }else{
                                    isShowForgotAlert = false
                                }
                                
                                activityText = "Sending password reset email…"
                                isLoading = true
                                authenticationViewModel.sendPasswordResetEmail(email: email) { isSuccessful, str in
                                    isLoading = false
                                    errorString = str ?? ""
                                    showingAlert = true
                                }*/
                                router.navigate(to: .forgotView)
                            }
                            .padding(.trailing, 24)
                            .padding(.bottom, 5)
                            .alert(errorString, isPresented: $showingAlert) {
                                Button("OK", role: .cancel) {}
                            }
                            .alert("Please fill your mail id firstly", isPresented: $isShowForgotAlert) {
                                Button("OK", role: .cancel) {}
                            }
                        }
                        
                        UsageDataView(usageDataImage: $usageDataImage, isEmailFocused: $isEmailFocused, isPasswordFocused: $isPasswordFocused, isSheetPresented: $isSheetPresented,buttonAction: { checkBox in
                            checkBoxSelected = checkBox
                            print(checkBoxSelected)
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        //.padding(.top, 24)
                        
                        

                        CustomPrimaryButtonView(text: "Continue", isButtonEnable: true/*validate()*/ ,showPleaseCompleteText: .constant((showEmailPleaseCompleteText && showPasswordPleaseCompleteText) ? true : false)) {
                            isEmailFocused = false
                            isPasswordFocused = false
                            isValidDataString = validate()
                            if isValidDataString != ""{
                               isValidData = true
                            } else {
                                isValidData = false
                                activityText = "Logging in…"
                                isLoading = true
                                isRectangleVisble = true
                                authenticationViewModel.doLogin(email: email, password: password) { isLoggedIn, errorStr, dict  in
                                    isLoading = false
                                    isRectangleVisble = false
                                    if isLoggedIn{
                                        DatabaseManager.shared.getUserDetail { userDetail, status in
                                            if status == 200{
                                                if let name = userDetail[FireStoreChatConstant.userFullName], let reminder = userDetail[FireStoreChatConstant.userReminderArr]{
                                                    addNotification()
                                                    USER_DEFAULTS.set("", forKey: "Logout")
                                                    USER_DEFAULTS.set("All Exist", forKey: LOGINTYPE)
                                                    introProgressTracker.isUserLoggedIn = true
                                                }else{
                                                    USER_DEFAULTS.set("", forKey: "Logout")
                                                    USER_DEFAULTS.set("Reminder not exist", forKey: LOGINTYPE)
                                                    router.navigate(to: .reminderView)
                                                }
                                                
                                            }else{
                                                let model = SignUpCompleteFlowModel(useFullName: dict.value(forKey: "fullName") as? String ?? "", userEmail: email, userComes: signUpTypeName.createSignup.rawValue, userAuthType: "FromWithoutSocial")
                                                SignUpCompleteViewModel.shared.addSignUpCompleteData(signUpType: .createSignup, signupModel: model){ status in
                                                    if status {
                                                        USER_DEFAULTS.set("", forKey: "Logout")
                                                        USER_DEFAULTS.set("Not exist", forKey: LOGINTYPE)
                                                        router.navigate(to: .stateView)
                                                    }else{
                                                        isCompleteAllData = true
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }else{
                                        errorString = errorStr ?? ""
                                        if errorString == "apple.com"{
                                            errorString = "Your account is already register with apple account"
                                        }else if errorString == "google.com"{
                                            errorString = "Your account is already register with google account"
                                        }else if errorString == "password"{
                                            errorString = "Invalid crediantial"
                                        }
                                        showingAlert = true
                                        /*if errorStr == FireStoreChatConstant.error {
                                            DatabaseManager.shared.getUserDetail { userDetail, status in
                                                if status == 200{
                                                    if let authType = userDetail["AuthType"]{
                                                        if authType as? String ?? "" == "FromGoogle"{
                                                            errorString = "Your account is already register with google account"
                                                            showingAlert = true
                                                        }else if authType as? String ?? "" == "FromApple"{
                                                            errorString = "Your account is already register with apple account"
                                                            showingAlert = true
                                                        }
                                                    }else{
                                                        introProgressTracker.fromWhereToNavigate = signUpTypeName.finishSignup.rawValue
                                                    }
                                                }
                                            }
                                        }*/
                                    }
                                }
                            }
                        }
                        .padding(.top, 24)
                        .alert(errorString, isPresented: $showingAlert) {
                            Button("OK", role: .cancel) {}
                        }.alert(FireStoreChatConstant.completeDataError, isPresented: $isCompleteAllData) {
                            Button("OK", role: .cancel) {}
                        }.alert(isValidDataString, isPresented: $isValidData) {
                            Button("OK", role: .cancel) {}
                        }
                        .navigationBarBackButtonHidden(true)
                        
                        CustomDivider(label: "OR", lineColor: .init(red: 224/255, green: 226/255, blue: 228/255), textColor: .init(red: 103/255, green: 116/255, blue: 137/255))
                        
                        AddSocialLoginButtonView {
                            isEmailFocused = false
                            isPasswordFocused = false
                            isLoading = true
                            isRectangleVisble = true
                            authenticationViewModel.doAppleSignIn { isLoggedIn, errorStr, dict in
                                isLoading = false
                                isRectangleVisble = false
                                if isLoggedIn{
                                    DatabaseManager.shared.getUserDetail { userDetail, status in
                                        if status == 200{
                                            if let name = userDetail[FireStoreChatConstant.userFullName], let reminder = userDetail[FireStoreChatConstant.userReminderArr]{
                                                addNotification()
                                                USER_DEFAULTS.set("", forKey: "Logout")
                                                USER_DEFAULTS.set("All Exist", forKey: LOGINTYPE)
                                                introProgressTracker.isUserLoggedIn = true
                                                AnalyticsHelper.logEvent(key: "appleSignIn", value: email)
                                            }else{
                                                USER_DEFAULTS.set("", forKey: "Logout")
                                                USER_DEFAULTS.set("Reminder not exist", forKey: LOGINTYPE)
                                                router.navigate(to: .reminderView)
                                            }
                                            
                                        }else{
                                            let model = SignUpCompleteFlowModel(useFullName: dict.value(forKey: "fullName") as? String ?? "", userEmail: dict.value(forKey: "email") as? String ?? "", userComes: signUpTypeName.createSignup.rawValue, userAuthType: "FromApple")
                                            SignUpCompleteViewModel.shared.addSignUpCompleteData(signUpType: .createSignup, signupModel: model){ status in
                                                if status {
                                                    USER_DEFAULTS.set("", forKey: "Logout")
                                                    USER_DEFAULTS.set("Not exist", forKey: LOGINTYPE)
                                                    router.navigate(to: .stateView)
                                                }else{
                                                    isCompleteAllData = true
                                                }
                                            }
                                        }
                                    }
                                    
                                }else{
                                    errorString = errorStr ?? ""
                                    showingAlert = true
                                }
                            }
                        } onGoogleClicked: {
                            isEmailFocused = false
                            isPasswordFocused = false
                            isLoading = true
                            isRectangleVisble = true
                            authenticationViewModel.doGoogleSignIn { isLoggedIn, errorStr, dict in
                                isLoading = false
                                isRectangleVisble = false
                                if isLoggedIn{
                                    DatabaseManager.shared.getUserDetail { userDetail, status in
                                        if status == 200{
                                            if let name = userDetail[FireStoreChatConstant.userFullName], let reminder = userDetail[FireStoreChatConstant.userReminderArr]{
                                                addNotification()
                                                USER_DEFAULTS.set("", forKey: "Logout")
                                                USER_DEFAULTS.set("All Exist", forKey: LOGINTYPE)
                                                introProgressTracker.isUserLoggedIn = true
                                                AnalyticsHelper.logEvent(key: "googleSignIn", value: email)
                                            }else{
                                                USER_DEFAULTS.set("", forKey: "Logout")
                                                USER_DEFAULTS.set("Reminder not exist", forKey: LOGINTYPE)
                                                router.navigate(to: .reminderView)
                                            }
                                            
                                        }else{
                                            let model = SignUpCompleteFlowModel(useFullName: dict.value(forKey: "fullName") as? String ?? "", userEmail: dict.value(forKey: "email") as? String ?? "", userComes: signUpTypeName.createSignup.rawValue, userAuthType: "FromGoogle")
                                            SignUpCompleteViewModel.shared.addSignUpCompleteData(signUpType: .createSignup, signupModel: model){ status in
                                                if status {
                                                    USER_DEFAULTS.set("", forKey: "Logout")
                                                    USER_DEFAULTS.set("Not exist", forKey: LOGINTYPE)
                                                    router.navigate(to: .stateView)
                                                }else{
                                                    isCompleteAllData = true
                                                }
                                            }
                                        }
                                    }
                                    
                                }else{
                                    errorString = errorStr ?? ""
                                    showingAlert = true
                                }
                            }
                        }
                        .padding(.bottom, 24)
                        .alert(errorString, isPresented: $showingAlert) {
                            Button("OK", role: .cancel) {}
                        }.alert(FireStoreChatConstant.completeDataError, isPresented: $isCompleteAllData) {
                            Button("OK", role: .cancel) {}
                        }
                        
                        Spacer(minLength: 120)
                        CustomBottomNavigationView(primaryText: "Don’t have an account yet?", secondaryText: "Sign up") {
    //                        self.goToSignUpPage = true
                            router.navigate(to: .signUpView)
                            //introProgressTracker.isUserLoggedIn = true
                        }
                        .padding(.bottom, 10)
                        .navigationBarBackButtonHidden(true)
                        
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
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color(.white))
        .onAppear{
            USER_DEFAULTS.set(false, forKey: FROMSIGNUP)
            if usageDataImage == "checkmark.square.fill"{
                USER_DEFAULTS.set(true, forKey: SHAREUSAGE)
            }else{
                USER_DEFAULTS.set(false, forKey: SHAREUSAGE)
            }
        }
    }
    func validate() -> String {
        if email.isEmpty || password.isEmpty {
            return "Fields can not be empty"
            
        }else if !(isValidEmail(email.trimmingCharacters(in: CharacterSet.whitespaces))) {
            return "Please enter valid email"
            
        }else if !checkBoxSelected {
            return "Please agree terms and conditions"
            
        }else{
            return ""
        }
        
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{3,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: testStr)
    }
    
    func addNotification(){
        DatabaseManager.shared.getUserDetail { userDetail, status in
            if status == 200{
                if let reminderData = userDetail[FireStoreChatConstant.userReminderArr] {
                    let reminderArr = reminderData as? [[String:Any]] ?? [[:]]
                    isLoading = false
                    settingsViewModel.setNotificationOnTimers(userDetail: reminderArr) { triggerArr,triggerDateArr  in
                        CustomNotification.shared.callNotification(triggerArr: triggerArr)
                        settings.updateReminderNotificationSetting(triggerDateArr)
                        settings.deleteReminderNotification = [:]
                    }
                }
            }
        }
    }
}

#Preview {
    AuthenticationView()
}
