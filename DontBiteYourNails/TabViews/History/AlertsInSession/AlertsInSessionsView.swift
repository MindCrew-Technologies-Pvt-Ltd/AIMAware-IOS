//
//  AlertsInSessionsView.swift
//  AImAware
//
//  Created by Sune on 21/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//


import SwiftUI

struct AlertsInSessionsView: View {
    @ObservedObject var viewModel: SessionAlertsViewModel
    let config = Config.shared
    var dataExportService = DataExportService.shared
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showShareSheet = false
    
    var body: some View {
        
        if #available(iOS 15.0, *) {
            
            VStack {
                if !viewModel.comment.isEmpty {
                    VStack {
                        BodyText(viewModel.comment).padding(.leading, 24)
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
                
                List(viewModel.alerts.filter { !$0.secondary }, id: \.self) { singleAlert in
                    NavigationLink(destination: AlertView(viewModel: AlertViewModel(alert: singleAlert, viewContext: viewContext))) {
                        BodyText("\(singleAlert.timestamp?.formatted() ?? "unknown"): \(singleAlert.status ?? "[error]")")
                    }/*.swipeActions(edge: .leading) {
                        Button {
                            dataExportService.exportData(alert : singleAlert)
                            // Your action for this button
                            print("Download action for \(singleAlert.timestamp?.formatted() ?? "unknown")")
                        } label: {
                            Label("Action", systemImage: "square.and.arrow.up")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            // Your action for this button
                            print("Second leading action for \(singleAlert.timestamp?.formatted() ?? "unknown")")
                        } label: {
                            Label("Action", systemImage: "circle")
                        }
                    }*/
                }.navigationBarTitle(" \(viewModel.sessionTime)")
                    .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)

            }
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
                        self.viewModel.shareFileUrl = dataExportService.createExportFile(session: viewModel.session, filename: "Session\(viewModel.urltimestamp)")
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
