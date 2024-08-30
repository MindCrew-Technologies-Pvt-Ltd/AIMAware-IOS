//
//  AddSocialLoginButtonView.swift
//  AImAware
//
//  Created by Suyog on 19/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct AddSocialLoginButtonView: View {
    var onAppleClicked: (() -> ())
    var onGoogleClicked: (() -> ())
    
    var body: some View {
        VStack(spacing: 0) {
            
            Button {
                self.onGoogleClicked()
            } label: {
                HStack {
                    Image("google")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                    Text("Log in with Google")
                        .fontWeight(.semibold)
                        .foregroundColor(Color("MainTextColor"))
                        .frame(height: 50)
                    
                }
                .background(Color(.white))
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .cornerRadius(10)
            .padding(.horizontal, 24)
            .background(Color(.white))
            .animation(.none, value: 0)
            .tint(Color("BorderColor"))
            .overlay{
                RoundedRectangle(cornerRadius: 5, style: .circular).stroke(Color("BorderColor"), lineWidth: 0.8)
            }.padding(.horizontal, 24).padding(.bottom, 10)
            
            
            Button {
                self.onAppleClicked()
            } label: {
                HStack {
                    Image("apple")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                    Text("Log in with Apple")
                        .fontWeight(.semibold)
                        .foregroundColor(Color("MainTextColor"))
                        .frame(height: 50)
                    
                }
                .background(Color(.white))
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .cornerRadius(10)
            .padding(.horizontal, 24)
            .background(Color(.white))
            .animation(.none, value: 0)
            .tint(Color("BorderColor"))
            .overlay{
                RoundedRectangle(cornerRadius: 5, style: .circular).stroke(Color("BorderColor"), lineWidth: 0.8)
            }.padding(.horizontal, 24)
            
        }
    }
}

#Preview {
    ZStack {
        Rectangle()
            .ignoresSafeArea()
        AddSocialLoginButtonView(onAppleClicked: {}){}
            .background(Color.white)
    }
}
