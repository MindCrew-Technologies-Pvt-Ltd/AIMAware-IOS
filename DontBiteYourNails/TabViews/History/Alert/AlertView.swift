//
//  AlertView.swift
//  AImAware
//
//  Created by Sune on 21/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//


import SwiftUI


struct AlertView: View {
    @ObservedObject var viewModel: AlertViewModel
    let config = Config.shared
    var dataExportService = DataExportService.shared
    @State private var showShareSheet = false
    
    var body: some View {
        if #available(iOS 15.0, *) {
            VStack {
                if !viewModel.comment.isEmpty {
                    VStack {
                        BodyText(viewModel.comment)
                        Button(action: {
                            viewModel.isEditingComment.toggle()
                        }) {
                            CustomButtonView("Edit comment")
                        }
                    }
                } else {
                    Button(
                        action: {viewModel.isEditingComment.toggle()
                        }) {
                            CustomButtonView("Add comment")
                        }
                }
                Spacer()
                
                VStack() {
                    BodyText("Nudge at time: \(viewModel.timestamp) was \(viewModel.status)").navigationBarTitle("Alert \(viewModel.timestamp)")
                        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
                    
                    if let feeling = viewModel.feeling {
                        BodyText("Feeling: \(feeling)")
                    }
                    
                    if let urge = viewModel.urge {
                        if urge > 0 {
                            BodyText("Urge: \(urge)")
                        }
                    }
                    
                    if let situation = viewModel.situation {
                        BodyText("Situation: \(situation)")
                    }
                }//.background(.white)
                
                
                /*Text(verbatim: "Number of motion data elements stored: \(viewModel.alert.alertMotionData?.count ?? 0)")*/
                Spacer()
            }
            .padding(.leading, 16)
            .padding(.top, 16)
            .background(Color(UIColor.systemGray6))// todo should be Color("BackgroundColor"), but should only be change when changing the navigation background color
            .sheet(isPresented: $viewModel.isEditingComment) {
                CommentEditingView(comment: $viewModel.comment)
                    .onDisappear {
                        viewModel.saveComment()
                    }
            }.navigationBarItems(trailing: Group {
                if (config.sharable) {
                    Button("Share") {
                        self.viewModel.shareFileUrl = dataExportService.createExportFile(alert: viewModel.alert, filename: "Alert\(viewModel.urltimestamp)")
                        print("URL is set to: \(String(describing: self.viewModel.shareFileUrl))")
                        showShareSheet = true
                    }}}
            ).sheet(isPresented: $showShareSheet) {
                if self.viewModel.shareFileUrl != nil {
                    ActivityViewController(activityItems: [self.viewModel.shareFileUrl!])
                } else {
                    BodyText("No file to share")
                }
                
            }
        }
    }
    
}


