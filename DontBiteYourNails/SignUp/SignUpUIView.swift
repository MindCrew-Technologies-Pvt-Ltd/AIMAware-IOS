//
//  SignUpUIView.swift
//  AImAware
//
//  Created by Suyog on 21/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct SignUpUIView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @FocusState private var isFullNameFocused: Bool
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @FocusState private var isConfirmPasswordFocused: Bool
    @State private var isValidData: Bool = false
    @State private var isValidDataString: String = ""
    @State private var showingAlert = false
    @State private var errorString: String = ""
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    @State private var isLoading = false
    @State var isRectangleVisble = false
    @State private var goToSignInPage = false
    @State private var activityText: String = ""
    @State private var showEmailPleaseCompleteText: Bool = false
    @State private var showPasswordPleaseCompleteText: Bool = false
    @State private var usageDataImage: String = "checkmark.square.fill"
    @State var isSheetPresented = false
    @State var checkBoxSelected = false
    @State var isCompleteAllData = false
    @EnvironmentObject var router: NavigationRouter
    var body: some View {
        VStack(spacing: 0) {
            ZStack{
                ScrollView {
                    VStack(spacing: 0){
                        
                        Spacer(minLength: 20)
                        Text("Sign up here!").frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 24)
                            .font(.setCustom(fontStyle: .title, fontWeight: .medium))
                            .foregroundColor(Color("MainTextColor"))
                        Spacer(minLength: 17)
                        
                        CustomTextFieldView(placeHolderLabel: "Enter your full name", topPlaceHolderLabel: "Full Name", text: $fullName, showPleaseCompleteText: $showEmailPleaseCompleteText, isFocused: $isFullNameFocused, returnKeyType: .next, keyboardType: .default) {
                            isFullNameFocused = false
                            isEmailFocused = true
                            //isPasswordFocused = true
                        }
                        
                        CustomTextFieldView(placeHolderLabel: "Enter your email", topPlaceHolderLabel: "Email", text: $email, showPleaseCompleteText: $showEmailPleaseCompleteText, isFocused: $isEmailFocused, returnKeyType: .next, keyboardType: .emailAddress) {
                            isEmailFocused = false
                            isPasswordFocused = true
                        }
                        
                        SecurePassTextFieldView(placeHolderLabel: "Enter your password", topPlaceHolderLabel: "Password", text: $password, showPleaseCompleteText: $showPasswordPleaseCompleteText, isFocused: $isPasswordFocused, returnKeyType: .next, keyboardType: .default) {
                            isPasswordFocused = false
                            isConfirmPasswordFocused = true
                            print("asdasdsda")
                        }
                        
                        SecurePassTextFieldView(placeHolderLabel: "Enter your confirm password", topPlaceHolderLabel: "Confirm Password", text: $confirmPassword, showPleaseCompleteText: $showPasswordPleaseCompleteText, isFocused: $isConfirmPasswordFocused, returnKeyType: .done, keyboardType: .emailAddress) {
                            isConfirmPasswordFocused = false
                            print("asdasdsda")
                        }
                        UsageDataView(usageDataImage: $usageDataImage, isEmailFocused: $isEmailFocused, isPasswordFocused: $isPasswordFocused, isSheetPresented: $isSheetPresented,buttonAction: { checkBox in
                            checkBoxSelected = checkBox
                            print(checkBoxSelected)
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        //.padding(.top, 24)
                        
                       

                        CustomPrimaryButtonView(text: "Continue",isButtonEnable: true/*validate()*/ ,showPleaseCompleteText: .constant((showEmailPleaseCompleteText && showPasswordPleaseCompleteText) ? true : false)) {
                            
                            isValidDataString = validate()
                            if isValidDataString != ""{
                               isValidData = true
                            }else {
                                isValidData = false
                                isEmailFocused = false
                                isPasswordFocused = false
                                if email.isEmpty{
                                    showEmailPleaseCompleteText = false
                                    return
                                } else {
                                    showEmailPleaseCompleteText = true
                                }
                                
                                if password.isEmpty{
                                    showPasswordPleaseCompleteText = false
                                    return
                                }else{
                                    showPasswordPleaseCompleteText = true
                                }
                                
                                activityText = "Creating…"
                                isLoading = true
                                isRectangleVisble = true
                                authenticationViewModel.doCreateUser(email: email, password: password) { isLoggedIn, errorStr in
                                    isLoading = false
                                    isRectangleVisble = false
                                    if isLoggedIn{
                                        DatabaseManager.shared.getUserDetail { userDetail, status in
                                            if status == 200{
                                                if let name = userDetail[FireStoreChatConstant.userFullName], let reminder = userDetail[FireStoreChatConstant.userReminderArr]{
                                                    USER_DEFAULTS.set("", forKey: "Logout")
                                                    introProgressTracker.isUserLoggedIn = true
                                                    AnalyticsHelper.logEvent(key: "googleSignIn", value: email)
                                                }else{
                                                   // introProgressTracker.fromWhereToNavigate = signUpTypeName.finishSignup.rawValue
                                                    USER_DEFAULTS.set("", forKey: "Logout")
                                                    router.navigate(to: .reminderView)
                                                }
                                                
                                            }else{
                                                //introProgressTracker.isUserLoggedIn = false
                                                let model = SignUpCompleteFlowModel(useFullName: fullName, userEmail: email, userComes: signUpTypeName.createSignup.rawValue, userAuthType: "FromWithoutSocial")
                                                SignUpCompleteViewModel.shared.addSignUpCompleteData(signUpType: .createSignup, signupModel: model){ status in
                                                    if status {
                                                        USER_DEFAULTS.set("", forKey: "Logout")
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
                                                USER_DEFAULTS.set("", forKey: "Logout")
                                                introProgressTracker.isUserLoggedIn = true
                                                AnalyticsHelper.logEvent(key: "appleSignIn", value: email)
                                            }else{
                                                //introProgressTracker.fromWhereToNavigate = signUpTypeName.finishSignup.rawValue
                                                USER_DEFAULTS.set("", forKey: "Logout")
                                                router.navigate(to: .reminderView)
                                                
                                            }
                                            
                                        }else{
                                            let model = SignUpCompleteFlowModel(useFullName: dict.value(forKey: "fullName") as? String ?? "", userEmail: dict.value(forKey: "email") as? String ?? "", userComes: signUpTypeName.createSignup.rawValue, userAuthType: "FromApple")
                                            SignUpCompleteViewModel.shared.addSignUpCompleteData(signUpType: .createSignup, signupModel: model){ status in
                                                if status {
                                                    USER_DEFAULTS.set("", forKey: "Logout")
                                                    router.navigate(to: .stateView)
                                                }else{
                                                    isCompleteAllData = true
                                                }
                                            }
                                            AnalyticsHelper.logEvent(key: "appleSignIn", value: email)
                                            print(userDetail)
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
                            authenticationViewModel.doGoogleSignIn { isLoggedIn, errorStr, dict  in
                                isLoading = false
                                isRectangleVisble = false
                                if isLoggedIn{
                                    
                                    DatabaseManager.shared.getUserDetail { userDetail, status in
                                        if status == 200{
                                            if let name = userDetail[FireStoreChatConstant.userFullName], let reminder = userDetail[FireStoreChatConstant.userReminderArr]{
                                                USER_DEFAULTS.set("", forKey: "Logout")
                                                introProgressTracker.isUserLoggedIn = true
                                                AnalyticsHelper.logEvent(key: "appleSignIn", value: email)
                                            }else{
                                                //introProgressTracker.fromWhereToNavigate = signUpTypeName.finishSignup.rawValue
                                                USER_DEFAULTS.set("", forKey: "Logout")
                                                router.navigate(to: .reminderView)
                                            }
                                            
                                        }else{
                                            let model = SignUpCompleteFlowModel(useFullName: dict.value(forKey: "fullName") as? String ?? "", userEmail: dict.value(forKey: "email") as? String ?? "", userComes: signUpTypeName.createSignup.rawValue, userAuthType: "FromGoogle")
                                            SignUpCompleteViewModel.shared.addSignUpCompleteData(signUpType: .createSignup, signupModel: model){ status in
                                                if status {
                                                    USER_DEFAULTS.set("", forKey: "Logout")
                                                    router.navigate(to: .stateView)
                                                }else{
                                                    isCompleteAllData = true
                                                }
                                            }
                                            //introProgressTracker.isUserLoggedIn = true
                                            AnalyticsHelper.logEvent(key: "googleSignIn", value: email)
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
                        }
                        .alert(FireStoreChatConstant.completeDataError, isPresented: $isCompleteAllData) {
                            Button("OK", role: .cancel) {}
                        }
                        
                        //Spacer(minLength: UIScreen.screenHeight - 130)
                        Spacer(minLength: 120)
                        CustomBottomNavigationView(primaryText: "Don’t have an account yet?", secondaryText: "Log In") {
                            self.goToSignInPage = true
                            router.navigateBack()
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
            
            USER_DEFAULTS.set(true, forKey: FROMSIGNUP)
            if usageDataImage == "checkmark.square.fill"{
                USER_DEFAULTS.set(true, forKey: SHAREUSAGE)
            }else{
                USER_DEFAULTS.set(false, forKey: SHAREUSAGE)
            }
        }
    }
    
    func validate() -> String {
        if fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            return "Fields can not be empty"
            
        }else if !isValidName(fullName){
            return "Full name accept only characters"
            
        }else if !(isValidEmail(email.trimmingCharacters(in: CharacterSet.whitespaces))) {
            return "Please enter valid email"
            
        }else if password.count < 6 {
            return "Password should contain atleast 6 character long"
            
        }else if password != confirmPassword {
            return "Password doesn't match"
            
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
    
    func isValidName(_ testStr:String) -> Bool {
        let CHARACTERS_Name = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
        
        let cs = NSCharacterSet(charactersIn: CHARACTERS_Name).inverted
        let filtered = testStr.components(separatedBy: cs).joined(separator: "")
        
        if (testStr == filtered) {
            
            return true
            
        } else {
            
            return false
        }
    }
}
//
//#Preview {
//    SignUpUIView()
//}
