//
//  ExperimentalGradientView.swift
//  AImAware
//
//  Created by Sune on 07/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct GradientBackgroundView: View {
    var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 56, bottomTrailingRadius: 56, topTrailingRadius: 0, style: .continuous)
                    .fill(LinearGradient.customGradient(endPoint: .bottom))
                    .frame(width: UIScreen.main.bounds.width)
                    .edgesIgnoringSafeArea(.all)
            } else {
                RoundedRectangle(cornerRadius: 56.0, style: .continuous)
                    .fill(LinearGradient.customGradient(endPoint: .bottom))
                    .frame(width: UIScreen.main.bounds.width)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct MinorGradientBackgroundView: View {
    let endPoint: UnitPoint
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                .fill(LinearGradient.customGradient(endPoint: endPoint))
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct MinorGradientBackgroundView2: View {
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color("TopFadeColor2"), Color("MiddleFadeColor2"), Color("ButtomFadeColor2")]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct MinorWhiteBackgroundView: View {
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                .fill(.white)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct GradientBackgroundView_Preview: PreviewProvider {
    
    static var previews: some View {
        VStack{
            VStack {
                Text("First Element")
                    .padding()
                Text("Second Element")
                    .padding()
                Text("Third Element")
                    .padding()
            }
            .background(GradientBackgroundView())
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
}
