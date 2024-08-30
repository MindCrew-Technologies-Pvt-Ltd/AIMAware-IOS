//
//  LoginButtonView.swift
//  AImAware
//
//  Created by Maulik Bhuptani on 20/02/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct PrimaryButtonView: View {
    var text: String
    var systemImage: String
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
                    Image(systemName: systemImage)
                        .font(.headline)
                        .foregroundColor(.white)
            }
            .background(Color("TopFadeColor"))
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .cornerRadius(10)
        .padding(.horizontal, 24)
        .buttonStyle(PrimaryButtonStyle())
    }
}

#Preview {
    ZStack {
        Rectangle()
            .ignoresSafeArea()
        PrimaryButtonView(text: "Login", systemImage: "arrow.right") {}
        .background(Color.white)
    }
}
