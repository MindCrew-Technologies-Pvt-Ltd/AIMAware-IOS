//
//  StatsView.swift
//  AImAware
//
//  Created by Suyog on 19/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    @State private var age: String = "1"
    @State private var height: String = ""
    @State private var gender: String = ""
    @State private var city: String = ""
    @State private var showEmailPleaseCompleteText: Bool = false
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    @State private var isAgeSelected: Bool = false
    @State private var isGenderSelected: Bool = false
    @FocusState private var isAgeFocused: Bool
    @FocusState private var isHeightFocused: Bool
    @FocusState private var isGenderFocused: Bool
    @FocusState private var isCityFocused: Bool
    @State private var errorString: String = "Please fill all the details"
    @State var showAlert = false
    @State var isCorrectAllFields = false
    @State var size: CGSize = .zero
    @State var isValidCityName = false
    @State var isValidHeight = false
    @State var isValidHeightValue = false
    @State var isCompleteAllData = false
    @EnvironmentObject var router: NavigationRouter
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0){
                    /*HStack() {
                        Button(action: {
                            
                        }, label: {
                            Image("back")
                        })
                        
                        
                        Spacer()
                    }
                    .padding(.leading, 24)
                    */
                    Text("Set up your stats").font(.setCustom(fontStyle: .title, fontWeight: .medium)).padding(.bottom, 16)
                    
                    CustomAgeDropDownTextFieldUIView(placeHolderLabel: "29", topPlaceHolderLabel: "Your age", text: $age, isAgeSelected: $isAgeSelected, isFocused: $isAgeFocused, selectedAgeVal: "1", onCommit: {
                    })
                    .onTapGesture {
                        isCityFocused = false
                        isHeightFocused = false
                        isGenderSelected = false
                        if isAgeSelected == true{
                            isAgeSelected = false
                        }else{
                            isAgeSelected = true
                            
                        }
                    }
                    
                    CustomShowTextFieldUIView(placeHolderLabel: "Enter your height", topPlaceHolderLabel: "Your height (In Cms)", text: $height, keyBoardType: .constant(.phonePad), placeholderText: .constant("Enter your height"), showPleaseCompleteText: $showEmailPleaseCompleteText, isFocused: $isHeightFocused, returnKeyType: .next) {
                        isHeightFocused = false
                        isCityFocused = true
                    }
                    
                    CustomGenderDropDownTextFieldView(placeHolderLabel: "Please Select", topPlaceHolderLabel: "How do you identify yourself?", text: $gender, isGenderSelected: $isGenderSelected, isFocused: $isGenderFocused) {
                        
                    }.onTapGesture {
                        isCityFocused = false
                        isHeightFocused = false
                        isAgeSelected = false
                        if isGenderSelected == true{
                            isGenderSelected = false
                        }else{
                            isGenderSelected = true
                            
                        }
                    }
                    
                    CustomTextFieldView(placeHolderLabel: "Enter your city", topPlaceHolderLabel: "Your city", text: $city, showPleaseCompleteText: $showEmailPleaseCompleteText, isFocused: $isCityFocused) {
                        isCityFocused = false
                    }
                    
                    Spacer(minLength: UIScreen.screenHeight -  600)
                    Button {
                        isCorrectAllFields = addValidation()
                        if isCorrectAllFields{
                            if isValidNumber(height) {
                                var validHeight : Int = Int(height) ?? 0
                                if validHeight > 0 {
                                    if isValidName(city){
                                        
                                        let model = SignUpCompleteFlowModel(userAge: age, userHeight: height, userGender: gender, userCity: city, userComes: signUpTypeName.stateSignup.rawValue)
                                        SignUpCompleteViewModel.shared.addSignUpCompleteData(signUpType: .stateSignup, signupModel: model){ status in
                                            if status {
                                                router.navigate(to: .habitView)
                                            }else{
                                                isCompleteAllData = true
                                            }
                                        }
                                    }else{
                                        isValidCityName = true
                                    }
                                }else{
                                    isValidHeightValue = true
                                }
                                
                            }else{
                                isValidHeight = true
                            }
                            
                        }else{
                            showAlert = true
                        }
                    } label: {
                        HStack {
                            Text("Continue")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(height: 50)
                                
                        }
                        .background(Color("TopFadeColor"))
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                    }
                    .navigationBarBackButtonHidden(true)
                    .background(Color("TopFadeColor"))
                    .animation(.none, value: 0)
                    .cornerRadius(10)
                    .padding(.horizontal, 24)
                    .alert(errorString, isPresented: $showAlert) {
                        Button("OK", role: .cancel) {}
                    }.alert("City accept only character", isPresented: $isValidCityName) {
                        Button("OK", role: .cancel) {}
                    }.alert("Height accept only numbers", isPresented: $isValidHeight) {
                        Button("OK", role: .cancel) {}
                    }.alert("Please enter actual height", isPresented: $isValidHeightValue) {
                        Button("OK", role: .cancel) {}
                    }.alert(FireStoreChatConstant.completeDataError, isPresented: $isCompleteAllData) {
                        Button("OK", role: .cancel) {}
                    }
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color(.white))
        
        
    }
    
    func addValidation() -> Bool {
        if (gender.isEmpty || height.isEmpty || city.isEmpty) {
            return false
            
        }
        return true
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
    
    func isValidNumber(_ testStr:String) -> Bool {
        let CHARACTERS_Name = "1234567890"
        
        let cs = NSCharacterSet(charactersIn: CHARACTERS_Name).inverted
        let filtered = testStr.components(separatedBy: cs).joined(separator: "")
        
        if (testStr == filtered) {
            
            return true
            
        } else {
            
            return false
        }
    }
}

#Preview {
    StatsView()
}

