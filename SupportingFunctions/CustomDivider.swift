//
//  CustomDivider.swift
//  AImAware
//
//  Created by Suyog on 19/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct CustomDivider: View {
    let label: String
    let horizontalPadding: CGFloat
    let lineColor: Color
    let textColor: Color

    init(label: String, horizontalPadding: CGFloat = 20, lineColor: Color, textColor: Color) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.lineColor = lineColor
        self.textColor = textColor
    }

    var body: some View {
        HStack {
            line
            Text(label).foregroundColor(textColor).font(.setCustom(fontStyle: .caption, fontWeight: .regular))
            line
        }.background(Color(.white))
    }

    var line: some View {
        VStack { Divider().background(lineColor) }.padding(horizontalPadding)
    }
}

#Preview {
    ZStack{
        Rectangle().ignoresSafeArea()
        CustomDivider(label: "OR", lineColor: .init(red: 224/255, green: 226/255, blue: 228/255), textColor: .init(red: 103/255, green: 116/255, blue: 137/255))
    }
    
}
