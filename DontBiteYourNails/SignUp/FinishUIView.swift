//
//  FinishUIView.swift
//  AImAware
//
//  Created by Suyog on 22/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct FinishUIView: View {
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    @State var isCompleteAllData = false
    @EnvironmentObject var router: NavigationRouter
    var body: some View {
        VStack{
            ZStack(){
                
                Image("FinishVector")
                    .resizable()
                    .frame(width: 255, height: 256)
                VStack{
                    Image("Shield")
                        .resizable()
                        .frame(width: 120, height: 141)
                        .padding(.bottom, 24)
                    Text("Great")
                        .font(.setCustom(fontStyle: .title, fontWeight: .medium))
                        .foregroundColor(Color("MainTextColor"))
                        .padding(.bottom, 12)
                    Text("Great! Now set up your app reminders")
                        .font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                        .foregroundColor(Color("TextFieldTextColor"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 70.0)
                }
            }
            .padding(.top, 211.0)
            Spacer()
            Button {
                //self.onClicked()
                
                let model = SignUpCompleteFlowModel(userComes: signUpTypeName.finishSignup.rawValue)
                SignUpCompleteViewModel.shared.addSignUpCompleteData(signUpType: .finishSignup, signupModel: model){ status in
                    if status {
                        router.navigate(to: .reminderView)
                    }else{
                        isCompleteAllData = true
                    }
                }
            } label: {
                HStack {
                    Text("Next")
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
            .alert(FireStoreChatConstant.completeDataError, isPresented: $isCompleteAllData) {
                Button("OK", role: .cancel) {}
            }

        }
    }
}

#Preview {
    FinishUIView()
}
