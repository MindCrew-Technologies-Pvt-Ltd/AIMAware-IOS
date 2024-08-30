//
//  StepsToFollowUIView.swift
//  AImAware
//
//  Created by Suyog on 20/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct StepsToFollowUIView: View {
    @State var firDatabase = DatabaseManager.shared
    @State var stepsToFollowListData = [StepsToFollowModel]()
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    @State var habitSelect = ""
    @State var subHabitSelect = ""
    @State var issubHabitSelect = false
    @State var isRectangleVisble = false
    @State private var isLoading = false
    @State var showAlert = false
    @State var isCompleteAllData = false
    @EnvironmentObject var router: NavigationRouter
    var body: some View {
        ZStack{
            VStack{
                HStack() {
                    Button(action: {
                        //introProgressTracker.fromWhereToNavigate = signUpTypeName.stateSignup.rawValue
                        router.navigateBack()
                    }, label: {
                        Image("back")
                    })
                    
                    Text("How it works").font(.setCustom(fontStyle: .title, fontWeight: .medium))
                        .foregroundColor(Color("MainTextColor"))
                    Spacer()
                }
                .padding(.leading, 21)
                .padding(.bottom, 16)
                //Text("How it works").font(.setCustom(fontStyle: .title, fontWeight: .medium))
                ScrollView {
                    ForEach(stepsToFollowListData.indices, id: \.self) { index in
                        Button {
                            /*subHabitSelect = stepsToFollowListData[index].name ?? ""
                            issubHabitSelect = true
                            
                            for indx in 0 ..< stepsToFollowListData.count {
                                var model = stepsToFollowListData[indx]
                                if model.name == subHabitSelect {
                                    model.isSelected = true
                                }else{
                                    model.isSelected = false
                                }
                                stepsToFollowListData[indx] = model
                            }*/
                            
                            
                        } label: {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(Color("MiddleFadeColor2"))
                                        .frame(width: 25, height: 25)
                                    if stepsToFollowListData[index].isSelected ?? false {
                                        Image(systemName: "checkmark")
                                            .font(.setCustom(fontStyle: .caption, fontWeight: .regular))
                                            .foregroundStyle(Color.white)
                                    }else{
                                        Text("\(index + 1)")
                                            .font(.setCustom(fontStyle: .caption, fontWeight: .regular))
                                            .foregroundStyle(Color.white)
                                    }
                                    
                                        
                                }
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color("MiddleFadeColor2"))
                                    HStack {
                                        ZStack {
                                            /*Circle()
                                                .fill(Color.white)
                                                .frame(width: 30,height: 30)*/
                                            let imageName = ""
                                            switch stepsToFollowListData[index].name ?? "" {
                                            case StepFollowName.phoneName.rawValue:
                                                Image("phone")
                                                    .resizable()
                                                    .frame(width: 30,height: 30)
                                                    
                                              case StepFollowName.installationName.rawValue:
                                                Image("watch")
                                                    .resizable()
                                                    .frame(width: 30,height: 30)
                                                    
                                              case StepFollowName.watchName.rawValue:
                                                Image("logo")
                                                    .resizable()
                                                    .frame(width: 30,height: 30)
                                                    
                                              case StepFollowName.playName.rawValue:
                                                Image("videoPlay")
                                                    .resizable()
                                                    .frame(width: 30,height: 30)
                                                
                                            case StepFollowName.approachName.rawValue:
                                              Image("face")
                                                  .resizable()
                                                  .frame(width: 30,height: 30)
                                                
                                            case StepFollowName.questionName.rawValue:
                                              Image("setting")
                                                  .resizable()
                                                  .frame(width: 30,height: 30)
                                                
                                            case StepFollowName.statsName.rawValue:
                                              Image("logoSearch")
                                                  .resizable()
                                                  .frame(width: 30,height: 30)
                                                    
                                              default:
                                                Image("check")
                                                    .resizable()
                                                    .frame(width: 30,height: 30)
                                            }
                                            
                                        }
                                        Text(stepsToFollowListData[index].name ?? "").padding(.vertical,25)
                                            .font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                                            .foregroundStyle(Color.white)
                                        Spacer()
                                    }.padding(.leading,21)
                                }
                                
                            }.padding(.horizontal,9)
                        }
                        .buttonStyle(NoTapAnimationStyle())

                    }
                }
                Button {
                    isLoading = true
                    isRectangleVisble = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading = false
                        isRectangleVisble = false
                    }
                    habitSelect = UserDefaults.standard.value(forKey: "HabitSelect") as? String ?? ""
                    let model = SignUpCompleteFlowModel(userHabit: habitSelect, userSubHabit: subHabitSelect, userComes: signUpTypeName.habitSignup.rawValue)
                    SignUpCompleteViewModel.shared.addSignUpCompleteData(signUpType: .habitSignup, signupModel: model){ status in
                        if status {
                            router.navigate(to: .finishView)
                        }else{
                            isCompleteAllData = true
                        }
                    }
                } label: {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("MiddleFadeColor2"))
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                       
                }
                .padding()
                .navigationBarBackButtonHidden(true)
                .alert(FireStoreChatConstant.completeDataError, isPresented: $isCompleteAllData) {
                    Button("OK", role: .cancel) {}
                }
                
               
            }.onAppear{
                firDatabase.getAllStepsToFollow { stepsToFollowData, status in
                    stepsToFollowListData = stepsToFollowData
                    
                }
            }
            
            if isRectangleVisble{
                Rectangle().fill(Color(.white)).opacity(0.8)
            }
            
            ActivityIndicatorView(text: "Loading...", isLoading: $isLoading)
            .frame(height: 20)
            .padding()
        }
    }
}

#Preview {
    StepsToFollowUIView()
}


struct NoTapAnimationStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // Make the whole button surface tappable. Without this only content in the label is tappable and not whitespace. Order is important so add it before the tap gesture
            .contentShape(Rectangle())
            .onTapGesture(perform: configuration.trigger)
    }
}
