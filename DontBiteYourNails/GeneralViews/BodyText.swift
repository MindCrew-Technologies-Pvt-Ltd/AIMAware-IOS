//
//  TabHeading.swift
//  AImAware
//
//  Created by Sune on 02/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct BodyText: View {
    let text: String
    let expand: Bool
    
    init(_ text: String, expand: Bool) {
        self.text = text
        self.expand = expand
    }
    
    init(_ text: String) {
        self.text = text
        self.expand = true
    }
    
    var body: some View {
        //Spacer()
          //  .frame(height: 20) // Top padding of 68px
        Text(text)
            .font(.body)
            .foregroundColor(Color("MainTextColor"))
            .fontWeight(.medium)// 500
            .multilineTextAlignment(.leading) // text-align: left
            .frame(alignment: .leading)
            .if(expand) {view in view.frame(maxWidth: .infinity, alignment: .leading)}
    }
}
