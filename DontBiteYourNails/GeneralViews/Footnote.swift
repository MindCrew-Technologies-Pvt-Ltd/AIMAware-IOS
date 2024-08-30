//
//  TabHeading.swift
//  AImAware
//
//  Created by Sune on 02/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct Footnote: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        //Spacer()
          //  .frame(height: 20) // Top padding of 68px
        Text(text)
            .font(.footnote)
            .foregroundColor(Color("FootnoteTextColor"))
            .fontWeight(.medium)// 500
            .multilineTextAlignment(.leading) // text-align: left
            .frame(alignment: .leading)
    }
}
