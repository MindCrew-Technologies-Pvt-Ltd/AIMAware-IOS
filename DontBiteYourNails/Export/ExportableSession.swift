//
//  ExportableSession.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 19/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation


struct ExportableSession : Encodable {
    var id : UUID?
    var comment : String?
    var startTime : Date?
    var endTime : Date?
    var isLeftHand : Bool
    var alerts : [ExportableAlert]
    var mlCalls : [ExportableMlCall]
    var motionData : [String]
    var taps : [Date]
    var artificialPositives : [ExportableArtificialPositive]
    var reportedErrors : [ExportableReportedError]
    var dataEpisodes : [ExportableDataEpisode]
    
    
    init(from session : Session) {
        self.id = session.id
        self.comment = session.comment ?? ""
        self.startTime = session.startTime
        self.endTime = session.endTime
        self.isLeftHand = session.isLeftHand
        
        if let events = session.events as? Set<SjEvent> { // the way events is divided is a bit of a mess. Should probably be a type and a description instead. Event are currently only used in the developer app, so I have not bothered making it nice.
            self.taps = events.filter{$0.type == SharedConstants.tap}.compactMap{$0.timestamp}
            self.artificialPositives = events.filter { $0.type?.starts(with: SharedConstants.artificialPositive + "|") ?? false}.compactMap{ExportableArtificialPositive(from: $0)}
            self.reportedErrors = events.filter { $0.type?.starts(with: SharedConstants.reportedError + "|") ?? false}.compactMap{ExportableReportedError(from: $0)}
            self.dataEpisodes = events.filter { $0.type?.starts(with: SharedConstants.dataEpisode + "|") ?? false}.compactMap{ExportableDataEpisode(from: $0)}
            print("events: \(events.count)")
            print("taps: \(taps.count)")
            print("artificialPositives: \(artificialPositives.count)")
            print("reportedErrors: \(reportedErrors.count)")
            print("dataEpisodes: \(dataEpisodes.count)")
        } else {
            self.taps = []
            self.artificialPositives = []
            self.reportedErrors = []
            self.dataEpisodes = []
        }
        
        
        
        if let alertSet = session.alerts as? Set<Alert> {
            self.alerts = alertSet.compactMap{ExportableAlert(from: $0)}
        } else {
            self.alerts = []
        }
        
        if let mlCallSet = session.mlCalls as? Set<MlCall> {
            self.mlCalls = mlCallSet.compactMap{ExportableMlCall(from: $0)}
        } else {
            self.mlCalls = []
        }
        
        let motionOrderedSet = session.sessionMotionData
        if  let motionArray = motionOrderedSet?.array as? [SessionMotionData] {
            self.motionData = motionArray.compactMap{ $0.data }
                //.map{ExportableMotionData(from: $0)}
        } else {
            self.motionData = []
        }
        
    }
    
    
}
