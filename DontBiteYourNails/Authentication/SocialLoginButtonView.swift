//
//  SocialLoginButtonView.swift
//  AImAware
//
//  Created by Maulik Bhuptani on 20/02/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct SocialLoginButtonView: View {
    var onAppleClicked: (() -> ())
    var onGoogleClicked: (() -> ())
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                self.onAppleClicked()
            } label: {
                HStack {
                    Text("Apple")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(height: 50)
                    Image("apple")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                }
                .background(Color("TopFadeColor"))
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .cornerRadius(10)
            .padding(.leading, 24)
            .padding(.trailing, 12)
            .buttonStyle(PrimaryButtonStyle())
            
            Button {
                self.onGoogleClicked()
            } label: {
                HStack {
                    Text("Google")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(height: 50)
                    Image("google")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                }
                .background(Color("TopFadeColor"))
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .cornerRadius(10)
            .padding(.leading, 12)
            .padding(.trailing, 24)
            .buttonStyle(PrimaryButtonStyle())
        }
    }
}

#Preview {
    ZStack {
        Rectangle()
            .ignoresSafeArea()
        SocialLoginButtonView(onAppleClicked: {}){}
            .background(Color.white)
    }
}
