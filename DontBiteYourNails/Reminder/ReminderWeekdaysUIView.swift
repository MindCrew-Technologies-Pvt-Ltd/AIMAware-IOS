//
//  ReminderWeekdaysUIView.swift
//  AImAware
//
//  Created by Suyog on 20/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct ReminderWeekdaysUIView: View {
   @State var array = [Weekdays(name: "Every Monday",isSelected: false),
                 Weekdays(name: "Every Tuesday",isSelected: false),
                 Weekdays(name: "Every Wednesday",isSelected: false),
                 Weekdays(name: "Every Thursday",isSelected: false),
                 Weekdays(name: "Every Friday",isSelected: false),
                 Weekdays(name: "Every Saturday",isSelected: false),
                 Weekdays(name: "Every Sunday",isSelected: false)]
    
    @State private var isBackToReminderView = false
    @State private var isSaveToReminderView = false
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    @State var weekDaysArray = [Weekdays]()
    @State private var errorString: String = "Please select any one of week days"
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var homeRouter: NavigationHomeRouter
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                HStack(spacing: 16) {
                    Button(action: {
                        if USER_DEFAULTS.value(forKey: LOGINTYPE) as? String ?? "" == "All Exist"{
                            homeRouter.navigateBack()
                        }else{
                            router.navigateBack()
                        }
                    }, label: {
                        Image("back")
                    })
                    Text("Back").font(.setCustom(fontStyle: .title, fontWeight: .medium))
                    Spacer()
                }.padding(.leading, 24)
                
                VStack{
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .frame(height: 294)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color("BorderColor"), lineWidth: 2)
                                
                            )
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
                                })
                            }
                        }
                        
                    }.padding(.horizontal, 24)
                    Spacer()
                    
                    Button {
                        if array.filter({$0.isSelected == true}).count <= 0 {
                            self.isBackToReminderView = true
                            self.isSaveToReminderView = false
                        }else{
                            introProgressTracker.introWeekDayArr = array.filter({$0.isSelected == true})
                            self.isBackToReminderView = false
                            self.isSaveToReminderView = true
                            if USER_DEFAULTS.value(forKey: LOGINTYPE) as? String ?? "" == "All Exist"{
                                homeRouter.navigateBack()
                            }else{
                                router.navigateBack()
                            }
                            
                        }
                    } label: {
                        HStack {
                            Text("Continue")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(height: 50)
                                
                        }
                        .background(Color("TopFadeColor"))
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .navigationBarBackButtonHidden(true)
                    .background(Color("TopFadeColor"))
                    .animation(.none, value: 0)
                    .cornerRadius(10)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 10)
                    .alert(errorString, isPresented: $isBackToReminderView) {
                        Button("OK", role: .cancel) {}
                    }
                    /*.fullScreenCover(isPresented: $isSaveToReminderView, content: {
                        ReminderUIView(weekDaysArray: $weekDaysArray)
                    })*/
                }
            }.onAppear{
                if introProgressTracker.introWeekDayArr.count > 0 {
                    for i in 0 ..< introProgressTracker.introWeekDayArr.count {
                        let introModel = introProgressTracker.introWeekDayArr[i]
                        for j in 0 ..< array.count {
                            let arrModel = array[j]
                            if introModel.name == arrModel.name{
                                array[j] = introModel
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ReminderWeekdaysUIView()
}

struct Weekdays: Codable {
    var name: String?
    var isSelected: Bool?
}
