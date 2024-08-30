//
//  TutorialView.swift
//  AImAware
//
//  Created by Suyog on 18/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI
struct Page {
    var outerImageName: String
    var innerImageName: String
    var title: String
}

struct TutorialView: View {
    @State private var showLoginView = false
    @State private var currentPage = 0
    @State private var currentIndexPage = 0
    @State private var isSkipButtonVisible = false
    @State private var isChangeButtonText = false
    @EnvironmentObject var router: NavigationRouter
    let pages = [
        Page(outerImageName: "FirstVector", innerImageName: "TutorialFrame", title: "AImaware is the app that helps you be the best version of yourself. How? We help you reshape your habits."),
        Page(outerImageName: "SecondVector", innerImageName: "alarm", title: "Receive a nudge when you are doing something you want to stop. It works when you use your hand to e.g. bite your nails."),
        Page(outerImageName: "ThirdVector", innerImageName: "BarChart", title: "AImAware can help you better understand your progress")
    ]
    
    var body: some View {
        VStack{
            Button (){
                 //showLoginView = true
                router.navigate(to: .loginView)
            } label: {
                
                Text("Skip")
                    .padding(.top, 30)
                    .padding(.trailing, 20)
                    .foregroundColor(Color("MiddleFadeColor2"))
                    .font(.setCustom(fontStyle: .callout, fontWeight: .regular))
                
            }.frame(
                maxWidth: .infinity,
                alignment: Alignment.topTrailing
            )
            .opacity(isSkipButtonVisible ? 0 : 1)
            
            /*.fullScreenCover(isPresented: $showLoginView, content: {
             AuthenticationView().transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
             }).opacity(isSkipButtonVisible ? 0 : 1)*/
            
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    TutorialLayoutView(page: self.pages[index]).onAppear {
                    }
                }
            }.onChange(of: currentPage) { newValue in
                if newValue == 2 {
                    self.isSkipButtonVisible = true
                    self.isChangeButtonText = true
                }else{
                    self.isSkipButtonVisible = false
                    self.isChangeButtonText = false
                }
            }
            .tabViewStyle(PageTabViewStyle())
            
            // Pagination dots
            HStack {
                ForEach(pages.indices, id: \.self) { index in
                    Circle()
                        .frame(width: 8, height: 8)
                    
                        .foregroundColor(index == currentPage ? .blue : .gray)
                }
            }
            .padding(.bottom)
            
            Button {
                if currentPage == 2 {
                    showLoginView = true
                    router.navigate(to: .loginView)
                    isChangeButtonText = true
                }else{
                    currentPage += 1
                    showLoginView = false
                }
            } label: {
                Text(isChangeButtonText ? "Start" : "Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("MiddleFadeColor2"))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                
            }.padding()
                .navigationBarBackButtonHidden(true)
            /*.fullScreenCover(isPresented: $showLoginView, content: {
             AuthenticationView()
             })*/
            
            
        }
    }
}


