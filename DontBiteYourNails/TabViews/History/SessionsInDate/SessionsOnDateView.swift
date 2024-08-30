//
//  SessionsOnDateView.swift
//  AImAware
//
//  Created by Sune on 21/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct SessionsOnDateView: View {
    @ObservedObject var viewModel: DaySessionsViewModel
    let config = Config.shared
    var dataExportService = DataExportService.shared
    @State private var showShareSheet = false
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        if #available(iOS 15.0, *) {
            List(viewModel.sessions, id: \.self) { singleSession in
                NavigationLink(destination: AlertsInSessionsView(viewModel: SessionAlertsViewModel(session: singleSession, viewContext: viewContext))){
                    VStack(alignment: .leading){
                        if let endTime = singleSession.endTime {
                            /*Text(verbatim: "Session that started \(singleSession.startTime!.formatted()) and ended \(endTime.formatted()).")*/
                            Text(verbatim: "\(singleSession.startTime!.formatted()) - \(endTime.formatted(date: .omitted, time: .shortened))")
                        } else {
                            Text(verbatim: "Session that started \(singleSession.startTime!.formatted()) has not ended yet.")
                        }
                        if (singleSession.deviceType == SharedConstants.watch) {
                            BodyText("Confirmed: \(singleSession.primaryAlerts?.filter{$0.status == AlertStatusEnum.confirmed.stringValue}.count ?? 0)")
                            BodyText("Ignored: \(singleSession.primaryAlerts?.filter{$0.status == AlertStatusEnum.ignored.stringValue}.count ?? 0)")
                            BodyText("Denied: \(singleSession.primaryAlerts?.filter{$0.status == AlertStatusEnum.denied.stringValue}.count ?? 0)")
                            if(singleSession.secondaryAlerts?.count ?? 0 > 0 ) {
                                BodyText("Indications of lifted arm: \(singleSession.secondaryAlerts?.count ?? 0)")
                            }
                        } else if (singleSession.deviceType == SharedConstants.phone) {
                            BodyText("Phone session")
                        }
                    }
                    
                }//.listRowBackground(singleSession.deviceType == SharedConstants.phone ? Color(UIColor.systemGray4) : Color(UIColor.systemGray6))
                    .navigationBarTitle(viewModel.dayStamp)
                    .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
            }.navigationBarItems(trailing:Group {
                if (config.sharable) {
                    Button("Share") {
                        self.viewModel.shareFileUrl = dataExportService.createExportFile(activeDate: viewModel.activeDate, filename: "Movementdata\(viewModel.urltimestamp)")
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
