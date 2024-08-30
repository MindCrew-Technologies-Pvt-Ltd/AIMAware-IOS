//
//  ExportableReportedError.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 21/09/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
struct ExportableReportedError: Encodable {
    var timestamp: Date?
    var description: String?
    
    init(from sjEvent : SjEvent) {
        self.timestamp = sjEvent.timestamp
        

        if let eventType = sjEvent.type, eventType.starts(with: SharedConstants.reportedError + "|") {
            let index = eventType.index(eventType.startIndex, offsetBy: SharedConstants.reportedError.count + 1)// to account for the pipe "|"
            self.description = String(eventType[index...])
        } else {
            print("Deduction of reportedError type failed. Type: \(sjEvent.type ?? "nil")")
        }
    }
}
