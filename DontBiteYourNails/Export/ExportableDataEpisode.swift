//
//  ExportableEvent.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 21/09/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

struct ExportableDataEpisode: Encodable {
    var timestampSaved: Date?
    var startTime: String?
    var endTime: String?
    var type: String?
    var subtype: String?
    
    init(from sjEvent : SjEvent) {
        self.timestampSaved = sjEvent.timestamp
        
        let components = sjEvent.type?.split(separator: "|").map { String($0) } ?? []

        if components.count == 5 && components[0] == SharedConstants.dataEpisode {
            self.startTime = components[1]
            self.endTime = components[2]
            self.type = components[3]
            self.subtype = components[4]
        } else {
            print("Deduction of ExportableDataEpisode type failed. Type: \(sjEvent.type!)")
        }
    }
}
