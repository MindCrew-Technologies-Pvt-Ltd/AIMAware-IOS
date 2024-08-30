//
//  DropDownTextFieldView.swift
//  AImAware
//
//  Created by Suyog on 19/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct CustomAgeDropDownTextFieldUIView: View {
    var placeHolderLabel: String
    var topPlaceHolderLabel: String
    @Binding var text: String
    @Binding var isAgeSelected : Bool
    @FocusState.Binding var isFocused: Bool
    @State var selectedAgeVal : String = "1"
    @State var ageModelListArray = [AgeModel]()
    var returnKeyType: SubmitLabel = .done
    var keyboardType: UIKeyboardType = .default
    
    var onCommit: () -> ()
    
    @State private var selectedCategory = "Chinese"
    var body: some View {
        VStack(){
            VStack(){
                    Text(topPlaceHolderLabel)
                    .font(.footnote)
                    .foregroundColor(Color("MainTextColor"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    //.padding(.bottom, 8)
                VStack{
                    HStack(){
                        
                        Button(action: {
                            
                            //self.showWeekdaysView = true
                        }, label: {
                            HStack {
                                Text(selectedAgeVal)
                                    .font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                                    .foregroundColor(Color("TextFieldTextColor"))
                                    .padding(.leading, 16)
                                Spacer()
                                Image("down")
                                    .padding(.trailing, 16)
                            }.frame(minHeight: 50)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                        })
                        
                    }
                    .disabled(true)
                    .frame(minHeight: 50)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if isAgeSelected == true {
                        VStack(alignment: .leading,spacing: 0) {
                            ForEach(ageModelListArray.indices, id: \.self) { index in
                                Button(action: {
                                    isAgeSelected = false
                                    let selectedModel = ageModelListArray[index]
                                    ageModelListArray = [AgeModel]()
                                    for num in 1 ... 100 {
                                        var model = AgeModel(ageVal: "\(num)", isSelected: false)
                                        if model.ageVal == selectedModel.ageVal{
                                            model.isSelected = true
                                            selectedAgeVal = model.ageVal ?? ""
                                            text = selectedAgeVal
                                        }else{
                                            model.isSelected = false
                                        }
                                        ageModelListArray.append(model)
                                    }
                                }, label: {
                                    VStack(spacing: 0) {
                                        HStack {
                                            
                                            Text(ageModelListArray[index].ageVal ?? "")
                                                .font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                                                .foregroundColor(Color("TextFieldTextColor"))
                                            Spacer()
                                            Image((ageModelListArray[index].isSelected ?? false) ? "rightImage" : "")
                                                .resizable()
                                                .frame(width: 24,height: 24)
                                        }.padding(.horizontal, 16).padding(.top,9)
                                            .padding(.bottom,9)
                                        if index != ageModelListArray.count - 1 {
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
                                ageModelListArray.append(model)
                            }
                        }
                    }
                    
                }.overlay{
                    RoundedRectangle(cornerRadius: 5, style: .circular).stroke(Color("BorderColor"), lineWidth: 0.8)
                }
                .padding(.horizontal, 24)
                
            }
            .padding(.bottom, 0)
        }
        .padding(.top, 8)
        .padding(.bottom, 16)
        .background(Color(.white))
        
    }

}
//
//#Preview {
//    ZStack {
//        Rectangle()
//            .ignoresSafeArea()
//        CustomAgeDropDownTextFieldUIView(placeHolderLabel: "29", topPlaceHolderLabel: "Your age", text: .constant(""), isAgeSelected: .constant(false), isFocused: FocusState<Bool>().projectedValue, selectedVal: .constant("1"), onCommit: {})
//            .background(Color.white)
//    }
//}

