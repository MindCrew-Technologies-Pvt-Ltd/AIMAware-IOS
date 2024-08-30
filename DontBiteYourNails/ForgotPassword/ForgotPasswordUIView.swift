//
//  ForgotPasswordUIView.swift
//  AImAware
//
//  Created by Suyog on 24/06/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct ForgotPasswordUIView: View {
    @State private var email: String = ""
    @FocusState private var isEmailFocused: Bool
    @State var isShowForgotAlert = false
    @State private var isLoading = false
    @State private var activityText: String = ""
    @State private var showingAlert = false
    @State private var errorString: String = ""
    @EnvironmentObject var router: NavigationRouter
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    @State private var showEmailPleaseCompleteText: Bool = false
    var body: some View {
        VStack(spacing: 0) {
            ZStack{
                ScrollView {
                    VStack(spacing: 0){
                        Spacer(minLength: 20)
                        Text("Enter your email to continue").frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 24)
                            .font(.setCustom(fontStyle: .title, fontWeight: .medium))
                            .foregroundColor(Color("MainTextColor"))
                        Spacer()
                        CustomTextFieldView(placeHolderLabel: "Enter your email", topPlaceHolderLabel: "Email", text: $email, showPleaseCompleteText: $showEmailPleaseCompleteText, isFocused: $isEmailFocused, returnKeyType: .next, keyboardType: .emailAddress) {
                            isEmailFocused = false
                        }
                        Spacer()
                        CustomPrimaryButtonView(text: "Submit", isButtonEnable: true/*validate()*/ ,showPleaseCompleteText: .constant((showEmailPleaseCompleteText) ? true : false)) {
                            isEmailFocused = false
                            let valiStr = validate()
                            if valiStr != ""{
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
                            }
                        }
                        .padding(.top, 24)
                        .alert(errorString, isPresented: $showingAlert) {
                            Button("OK", role: .cancel) {
                                router.navigateBack()
                            }
                        }
                        .alert(errorString/*"Please fill your mail id firstly"*/, isPresented: $isShowForgotAlert) {
                            Button("OK", role: .cancel) {}
                        }
                        .navigationBarBackButtonHidden(true)
                        Spacer()
                        CustomBottomNavigationView(primaryText: "Don’t have an account yet?", secondaryText: "Log in") {
                            router.navigateBack()
                        }
                        .padding(.bottom, 10)
                    }
                }
                ActivityIndicatorView(text: activityText, isLoading: $isLoading)
                    .frame(height: 20)
                    .padding(.top, 15)
            }
        }
    }
    
    func validate() -> String {
        if email.isEmpty {
            return "Fields can not be empty"
            
        }else if !(isValidEmail(email.trimmingCharacters(in: CharacterSet.whitespaces))) {
            return "Please enter valid email"
            
        }else{
            return ""
        }
        
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{3,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: testStr)
    }

}

#Preview {
    ForgotPasswordUIView()
}
