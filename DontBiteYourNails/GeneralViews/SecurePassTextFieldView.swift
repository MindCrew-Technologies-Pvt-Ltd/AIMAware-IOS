//
//  SecurePassTextFieldView.swift
//  AImAware
//
//  Created by Suyog on 19/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct SecurePassTextFieldView: View {
    var placeHolderLabel: String
    var topPlaceHolderLabel: String
    @Binding var text: String
    @Binding var showPleaseCompleteText: Bool
    @FocusState.Binding var isFocused: Bool
    var returnKeyType: SubmitLabel = .done
    var keyboardType: UIKeyboardType = .default
    var onCommit: () -> ()

    var body: some View {
        VStack(spacing: 0){
            VStack(spacing: 0){
                    Text(topPlaceHolderLabel)
                    .font(.footnote)
                    .foregroundColor(Color("MainTextColor"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
                
                HStack(spacing: 0){
                    SecureField(placeHolderLabel, text: $text, onCommit: {
                        onCommit()
                    })
                        .font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                        .tint(Color("TextFieldTextColor"))
                        .focused($isFocused)
                        .keyboardType(keyboardType)
                        .submitLabel(returnKeyType)
                        .foregroundColor(Color("TextFieldTextColor"))
                        .autocapitalization(.none)
                        .frame(minHeight: 30)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.white)
                }
                .onChange(of: text) {
                    print(text.count)
                    print($0)
                   // loginSignupSettings.showEmailText = true
                    CustomPrimaryButtonView(text: "Login", showPleaseCompleteText: .constant(false)) {}
                }
                .frame(minHeight: 50)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay{
                    /*if showPleaseCompleteText{
                        RoundedRectangle(cornerRadius: 5, style: .circular).stroke(.red, lineWidth: 0.8)
                    }else{*/
                        RoundedRectangle(cornerRadius: 5, style: .circular).stroke(Color("BorderColor"), lineWidth: 0.8)
                    //}
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 0)
        }
        .padding(.top, 8)
        .padding(.bottom, 16)
        .background(Color(.white))
    }
}

#Preview {
    ZStack {
        Rectangle()
            .ignoresSafeArea()
        SecurePassTextFieldView(placeHolderLabel: "Type here your password", topPlaceHolderLabel: "Password", text: .constant(""), showPleaseCompleteText: .constant(false), isFocused: FocusState<Bool>().projectedValue, onCommit: {})
        .background(Color.white)
    }
}
