//
//  CustomGenderDropDownTextFieldView.swift
//  AImAware
//
//  Created by Suyog on 23/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct CustomGenderDropDownTextFieldView: View {
    var placeHolderLabel: String
    var topPlaceHolderLabel: String
    @Binding var text: String
    @Binding var isGenderSelected : Bool
    @FocusState.Binding var isFocused: Bool
    @State var selectedGenderVal : String = "Select your gender"
    @State var genderModelListArray = [GenderModel]()
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
                                Text(selectedGenderVal)
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
                    
                    
                    if isGenderSelected == true {
                        VStack(alignment: .leading,spacing: 0) {
                            ForEach(genderModelListArray.indices, id: \.self) { index in
                                Button(action: {
                                    isGenderSelected = false
                                    let selectedModel = genderModelListArray[index]
                                    for indx in 0 ..< genderModelListArray.count {
                                        var model = genderModelListArray[indx]
                                        if model.genderVal == selectedModel.genderVal{
                                            model.isSelected = true
                                            selectedGenderVal = model.genderVal ?? ""
                                            text = selectedGenderVal
                                            genderModelListArray[indx] = model
                                        }else{
                                            model.isSelected = false
                                            genderModelListArray[indx] = model
                                        }
                                    }
                                }, label: {
                                    VStack(spacing: 0) {
                                        HStack {
                                            
                                            Text(genderModelListArray[index].genderVal ?? "")
                                                .font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                                                .foregroundColor(Color("TextFieldTextColor"))
                                            Spacer()
                                            Image((genderModelListArray[index].isSelected ?? false) ? "rightImage" : "")
                                                .resizable()
                                                .frame(width: 24,height: 24)
                                        }.padding(.horizontal, 16).padding(.top,9)
                                            .padding(.bottom,9)
                                        if index != genderModelListArray.count - 1 {
                                            Rectangle()
                                                .fill(Color("ButtonDisableColor"))
                                                .frame(maxWidth: .infinity, maxHeight: 1)
                                        }
                                    }
                                })
                            }
                        }.background(Color(.white))
                        .onAppear{
                            genderModelListArray = [GenderModel(genderVal: "Male",isSelected: false),
                                      GenderModel(genderVal: "Female",isSelected: false),
                                      GenderModel(genderVal: "Other",isSelected: false),
                                      GenderModel(genderVal: "Prefer not to say",isSelected: false)]
                        }
                    }
                }
                .overlay{
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
//    CustomGenderDropDownTextFieldView(placeHolderLabel: "29", topPlaceHolderLabel: "Your age", text: .constant(""), isGenderSelected: .constant(false), isFocused: FocusState<Bool>().projectedValue, onCommit: {})
//        .background(Color.white)
//}
