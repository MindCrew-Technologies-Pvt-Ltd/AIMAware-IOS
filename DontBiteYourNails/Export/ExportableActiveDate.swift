//
//  ExportableActiveDate.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 20/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

struct ExportableActiveDate : Encodable {
    var comment : String?
    var date : Date?
    var sessions : [ExportableSession]
        
    init(from activeDate : ActiveDate) {
        self.comment = activeDate.comment
        self.date = activeDate.date

        if let sessionSet = activeDate.sessions as? Set<Session> {
            self.sessions = sessionSet.compactMap{ExportableSession(from: $0)}
        } else {
            self.sessions = []
        }
        
    }
}
    