//
//  UsageDataView.swift
//  AImAware
//
//  Created by Maulik Bhuptani on 28/02/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct UsageDataView: View {
    @Binding var usageDataImage: String
    @FocusState.Binding var isEmailFocused: Bool
    @FocusState.Binding var isPasswordFocused: Bool
    @Binding var isSheetPresented: Bool
    @State var isCheckBoxSeleted = false
    var buttonAction: ((Bool) -> Void)?
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                isCheckBoxSeleted.toggle()
                if usageDataImage == "apple" {
                    usageDataImage = "apple"
                    USER_DEFAULTS.set(false, forKey: SHAREUSAGE)
                } else {
                    usageDataImage = "apple"
                    USER_DEFAULTS.set(true, forKey: SHAREUSAGE)
                }
               buttonAction?(isCheckBoxSeleted)
            } label: {
                Image(isCheckBoxSeleted ? "check" : "uncheck")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 12)
            }
            //.buttonStyle(CheckmarkButtonStyle())
            Text("Accept the ")
                .font(.setCustom(fontStyle: .caption, fontWeight: .regular))
            Button {
                isSheetPresented = true
            } label: {
                Text("Privacy policy & Terms & conditions")
                    .font(.setCustom(fontStyle: .caption, fontWeight: .bold))
                    .foregroundColor(Color(red: 62/255, green: 156/255, blue: 226/255))
            }.sheet(isPresented: $isSheetPresented) {
                HTMLView(fileName: "usage")
            }
            
            /*SecondaryButtonView(text: "I agree to share the usage data", foregroundColor: Color("FootnoteTextColor"), separatorColor: Color("FootnoteTextColor")) {
                isEmailFocused = false
                isPasswordFocused = false
                isSheetPresented = true
            }
            .sheet(isPresented: $isSheetPresented) {
                HTMLView(fileName: "usage")
            }*/
        }
    }
}

#Preview {
    ZStack {
        Rectangle()
            .ignoresSafeArea()
        UsageDataView(usageDataImage: .constant("apple"), isEmailFocused: FocusState<Bool>().projectedValue, isPasswordFocused: FocusState<Bool>().projectedValue, isSheetPresented: .constant(false))
            .background(Color.white)
    }
}
