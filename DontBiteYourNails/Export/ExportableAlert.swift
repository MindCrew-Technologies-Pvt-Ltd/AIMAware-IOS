//
//  ExportableAlert.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 19/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

struct ExportableAlert : Encodable {
    var id : UUID?
    var comment : String
    var sessionComment : String
    var status : String
    var timestamp : Date
    var data : String
    var calibrationData : String
    var userAnswers : String
    var secondary : Bool
    var userAlerted : Bool
    var handStillNearPosition : Bool
    
    init(from alert : Alert) {
        self.id = alert.id
        self.comment = alert.comment ?? ""
        self.sessionComment = alert.session?.comment ?? ""
        self.status = alert.status ?? ""
        self.timestamp = alert.timestamp ?? Date(timeIntervalSince1970: 0)
        self.userAnswers = alert.userAnswers ?? ""
        self.secondary = alert.secondary
        self.userAlerted = alert.userAlerted
        self.handStillNearPosition = alert.handStillNearPosition
        
        if let calibrationDataSet = alert.alertMotionData as? Set<AlertMotionData>{
            self.calibrationData = calibrationDataSet
                .filter{ $0.type == "calibration"}
                .compactMap{ $0.data }
                .reduce("", +)
            
        } else {
            self.calibrationData = "No calibration data"
        }
        
        if let activeDataSet = alert.alertMotionData as? Set<AlertMotionData> {
            self.data = activeDataSet
                .filter{ $0.type == "active" }
                .compactMap{ $0.data }
                .reduce("", +)
        } else {
            self.data = "No active data"
        }

    }
    
    
}
