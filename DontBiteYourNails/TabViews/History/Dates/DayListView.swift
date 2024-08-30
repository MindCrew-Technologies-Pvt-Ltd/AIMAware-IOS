//
//  DayListView.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 06/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
import Combine

struct DaysListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: DayListViewModel
    
    @ObservedObject var summariseService = SummariseService.shared
    
    var body: some View {
        if #available(iOS 15.0, *) {
            // TODO ensure background is 'our' blue not just grey
            VStack{
                
                List(viewModel.activeDates, id: \.self) { activeDate in
                    
                    NavigationLink(destination: SessionsOnDateView(viewModel: DaySessionsViewModel(activeDate: activeDate))) {
                        
                        VStack(alignment: .leading){
                            /*Text(verbatim: "On \(activeDate.date!.formatted(date: .long, time: .omitted)) you had \(activeDate.sessions?.count ?? 0) sessions for a total time of \(summariseService.totalSessionTimeHHMM(activeDate: activeDate))")*/
                            BodyText("\(activeDate.date!.formatted(date: .abbreviated, time: .omitted)) total time: \(summariseService.totalSessionTimeHHMM(activeDate: activeDate))")
                            BodyText("Confirmed: \(summariseService.countAlertsForActiveDate(activeDate: activeDate, status: AlertStatusEnum.confirmed))")
                            BodyText("Ignored: \(summariseService.countAlertsForActiveDate(activeDate: activeDate, status: AlertStatusEnum.ignored))")
                            BodyText("Denied: \(summariseService.countAlertsForActiveDate(activeDate: activeDate, status: AlertStatusEnum.denied))")
                        }
                    }//.listRowBackground(Color.green)
                    
                }
                //.background(Color.purple.edgesIgnoringSafeArea(.all))
            }.onAppear{
                AnalyticsHelper.logCreatedEvent(key: "view_history", value: SignUpCompleteViewModel.shared.getCurrentUserId() ?? "")
            }
            .padding(.top, 1)
                .background(Color(UIColor.systemGray6))// todo should be Color("BackgroundColor"), but should only be change when changing the navigation background color
                
            
        } else {
            BodyText("This view is only supported by iOS15 and newer.")
        }
    }
}
