//
//  Subheading.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct Heading: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.title2)
            .foregroundColor(Color("MainTextColor"))
            .fontWeight(.medium)// 500
            .lineSpacing(15) // Adjust this value as needed to simulate line-height: 29px
            .multilineTextAlignment(.leading) // text-align: left
            .frame(alignment: .leading)
    }
}
