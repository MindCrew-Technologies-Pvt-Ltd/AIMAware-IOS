//
//  CustomButtonView.swift
//  AImAware
//
//  Created by Sune on 03/02/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct CustomButtonView: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
            Text(text)
                .font(.body)
                .foregroundColor(.white)
                .fontWeight(.medium)// 500
                .multilineTextAlignment(.leading) // text-align: left
                .frame(alignment: .leading)
                .padding(8)
                .background(Color("TopFadeColor"))
                .cornerRadius(8)
    }
}
    
    
