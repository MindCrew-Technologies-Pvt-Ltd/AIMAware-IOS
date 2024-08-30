//
//  CustomTextFieldView.swift
//  AImAware
//
//  Created by Suyog on 19/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct CustomTextFieldView: View {
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
                    //.foregroundColor(showPleaseCompleteText ? .red : Color("MainTextColor"))
                    .foregroundColor(Color("MainTextColor"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
                
                HStack(spacing: 0){
                    TextField(placeHolderLabel, text: $text, onCommit: {
                        onCommit()
                    })
                    .onChange(of: text) {
                        print(text.count)
                        print($0)
                    }
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
                .frame(minHeight: 50)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay{
                    
                    RoundedRectangle(cornerRadius: 5, style: .circular).stroke(Color("BorderColor"), lineWidth: 0.8)
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
        CustomTextFieldView(placeHolderLabel: "Enter your email", topPlaceHolderLabel: "Email", text: .constant(""), showPleaseCompleteText: .constant(false), isFocused: FocusState<Bool>().projectedValue, onCommit: {})
            .background(Color.white)
    }
}
