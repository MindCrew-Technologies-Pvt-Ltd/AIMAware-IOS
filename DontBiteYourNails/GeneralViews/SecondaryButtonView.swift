//
//  SecondaryButtonView.swift
//  AImAware
//
//  Created by Maulik Bhuptani on 27/02/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct SecondaryButtonView: View {
    var text: String
    var foregroundColor: Color = Color("TopFadeColor")
    var separatorColor: Color = Color("TopFadeColor")
    var onClicked: (() -> ())
    
    var body: some View {
        Button {
            onClicked()
        } label: {
            VStack(spacing: 0){
                Text(text)
                    .font(.caption)
                    .foregroundColor(foregroundColor)
                    .fontWeight(.medium)
                    .overlay {
                        //BottomSeparatorView(backgroundColor: separatorColor)
                    }
            }
            .fixedSize()
        }
        .buttonStyle(SecondaryButtonStyle())
    }
}

#Preview {
    ZStack {
        Rectangle()
            .ignoresSafeArea()
        SecondaryButtonView(text: "Forgotten your password?", onClicked: {})
            .background(Color.white)
    }
}
