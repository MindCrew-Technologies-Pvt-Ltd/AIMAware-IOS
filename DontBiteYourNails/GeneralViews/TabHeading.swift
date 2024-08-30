//
//  TabHeading.swift
//  AImAware
//
//  Created by Sune on 02/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct TabHeading: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        //Spacer()
          //  .frame(height: 20) // Top padding of 68px
        Text(text)
            .font(.title)
            .foregroundColor(Color("MainTextColor"))
            .fontWeight(.medium)// 500
            .lineSpacing(5) // Adjust this value as needed to simulate line-height: 29px
            .multilineTextAlignment(.leading) // text-align: left
            .frame(alignment: .leading)
    }
}
