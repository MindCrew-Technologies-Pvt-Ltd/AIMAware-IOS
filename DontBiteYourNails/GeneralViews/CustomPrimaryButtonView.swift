//
//  CustomPrimaryButtonView.swift
//  AImAware
//
//  Created by Suyog on 19/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct CustomPrimaryButtonView: View {
    var text: String
    var isButtonEnable = true
    @Binding var showPleaseCompleteText: Bool
    var onClicked: (() -> ())
    
    var body: some View {
        Button {
            self.onClicked()
        } label: {
            HStack {
                Text(text)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    
            }
            .background(/*isButtonEnable ? Color("ButtonDisableColor") :*/ Color("TopFadeColor"))
            .frame(maxWidth: .infinity, alignment: .center)
        }
        //.disabled(isButtonEnable)
        .background(/*isButtonEnable ? Color("ButtonDisableColor") : */Color("TopFadeColor"))
        .animation(.none, value: 0)
        .cornerRadius(10)
        .padding(.horizontal, 24)
        
        //.buttonStyle(PrimaryButtonStyle())
    }
}

#Preview {
    ZStack {
        Rectangle()
            .ignoresSafeArea()
        CustomPrimaryButtonView(text: "Login", showPleaseCompleteText: .constant(false)) {}
        .background(Color.white)
    }
}
