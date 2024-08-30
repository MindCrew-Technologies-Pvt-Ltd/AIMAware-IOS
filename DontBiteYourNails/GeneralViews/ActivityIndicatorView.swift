//
//  ActivityIndicatorView.swift
//  AImAware
//
//  Created by Maulik Bhuptani on 26/02/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct ActivityIndicatorView: View {
    var text: String
    @Binding var isLoading: Bool

    var body: some View {
        GeometryReader{ geometry in
            HStack(alignment: .center) {
                if isLoading {
                    ProgressView()
                        .foregroundColor(Color("MainTextColor"))
                        .tint(Color("MainTextColor"))
                    Text(text)
                        .foregroundColor(Color("MainTextColor"))
                }else{
                    EmptyView()
                }
            }.frame(width: geometry.size.width,
                    height: geometry.size.height )
        }
        
    }
}

#Preview {
    ZStack {
        Rectangle()
            .ignoresSafeArea()
        ActivityIndicatorView(text: "Logging in…", isLoading: .constant(true))
            .background(Color.white)
    }
    
}
