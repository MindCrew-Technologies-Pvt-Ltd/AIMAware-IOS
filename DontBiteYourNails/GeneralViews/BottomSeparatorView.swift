//
//  BottomSeparatorView.swift
//  AImAware
//
//  Created by Maulik Bhuptani on 27/02/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct BottomSeparatorView: View {
    var backgroundColor: Color = Color("TopFadeColor")
    var height: CGFloat = 1
    
    var body: some View {
        VStack(spacing: 0){
            Spacer()
            Divider()
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(backgroundColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.clear)
    }
}

#Preview {
    BottomSeparatorView()
}
