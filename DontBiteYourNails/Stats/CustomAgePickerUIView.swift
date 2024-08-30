//
//  CustomPickerUIView.swift
//  AImAware
//
//  Created by Suyog on 23/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct CustomAgePickerUIView: View {
    @State var array = [AgeModel]()
    @State var ishow = false
    @State private var selectedVal = "1"
    var body: some View {
        VStack(alignment: .leading,spacing: 0) {
            ForEach(array.indices, id: \.self) { index in
                Button(action: {
                    let selectedModel = array[index]
                    array = [AgeModel]()
                    for num in 1 ... 100 {
                        var model = AgeModel(ageVal: "\(num)", isSelected: false)
                        if model.ageVal == selectedModel.ageVal{
                            model.isSelected = true
                            selectedVal = model.ageVal ?? ""
                        }else{
                            model.isSelected = false
                        }
                        array.append(model)
                    }
                }, label: {
                    VStack(spacing: 0) {
                        HStack {
                            
                            Text(array[index].ageVal ?? "")
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
                })
            }
        }.background(Color(.white))
        .onAppear{
            for num in 1 ... 100 {
                let model = AgeModel(ageVal: "\(num)", isSelected: false)
                array.append(model)
            }
        }
    }
}

#Preview {
    ZStack{
        Rectangle().ignoresSafeArea()
        CustomAgePickerUIView()
    }
    
}


