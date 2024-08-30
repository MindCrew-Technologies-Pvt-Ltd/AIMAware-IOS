//
//  CustomGenderPickerUIView.swift
//  AImAware
//
//  Created by Suyog on 23/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct CustomGenderPickerUIView: View {
    @State var array = [Weekdays(name: "Male",isSelected: false),
                  Weekdays(name: "Female",isSelected: false),
                  Weekdays(name: "Other",isSelected: false),
                  Weekdays(name: "Prefer  not to say",isSelected: false)]
    @State var ishow = false
    var body: some View {
        VStack(alignment: .leading,spacing: 0) {
            ForEach(array.indices, id: \.self) { index in
                Button(action: {
                    var model = array[index]
                    if model.isSelected == true {
                        model.isSelected = false
                    } else {
                        model.isSelected = true
                    }

                   array[index] = model
                }, label: {
                    VStack(spacing: 0) {
                        HStack {
                            Text(array[index].name ?? "")
                                .font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                                .foregroundColor(Color("TextFieldTextColor"))
                            Spacer()
                            Image((array[index].isSelected ?? false) ? "rightImage" : "")
                                .resizable()
                                .frame(width: 24,height: 24)
                        }.padding(.horizontal, 16).padding(.top,9)
                            .padding(.bottom,9)
                        if index != array.count - 1 {
                            Rectangle()
                               .fill(Color("ButtonDisableColor"))
                               .frame(maxWidth: .infinity, maxHeight: 1)
                        }
                         
                    }
                }).buttonStyle(PlainButtonStyle())
            }
        }.background(Color(.white))
        
    }
}

#Preview {
    CustomGenderPickerUIView()
}
