//
//  GradientBackgroundView.swift
//  AImAware
//
//  Created by Sune on 07/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//
import SwiftUI

struct GradientBackgroundViewOld: View {
    var body: some View {
            VStack {
                if #available(iOS 16.0, *) {
                    UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 56, bottomTrailingRadius: 56, topTrailingRadius: 0, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("TopFadeColor"), Color("MiddleFadeColor"), Color("ButtomFadeColor")]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: UIScreen.main.bounds.width)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    RoundedRectangle(cornerRadius: 56.0, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("TopFadeColor"), Color("MiddleFadeColor"), Color("ButtomFadeColor")]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: UIScreen.main.bounds.width)
                        .edgesIgnoringSafeArea(.all)
                }
            }
    }
}

struct GradientBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GradientBackgroundView()
            VStack {
                Text("First Element")
                    .padding()
                Text("Second Element")
                    .padding()
                Text("Third Element")
                    .padding()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }.edgesIgnoringSafeArea(.all)
        
    }
}
