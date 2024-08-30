//
//  ExportableEvent.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 21/09/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

struct ExportableArtificialPositive: Encodable {
    var timestamp: Date?
    var bodyPosition: String?
    var handStartPosition: String?
    var targetArea: String?
    var specificTarget: String?
    
    init(from sjEvent : SjEvent) {
        self.timestamp = sjEvent.timestamp
        
        let components = sjEvent.type?.split(separator: "|").map { String($0) } ?? []

        if components.count == 5 && components[0] == SharedConstants.artificialPositive {
            self.bodyPosition = components[1]
            self.handStartPosition = components[2]
            self.targetArea = components[3]
            self.specificTarget = components[4]
        } else {
            print("Deduction of artificialPositive type failed. Type: \(sjEvent.type!)")
        }
    }
}
