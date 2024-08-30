//
//  SessionActionEnum.swift
//  DontBiteYourNails WatchKit Extension
//
//  Created by Sune Kristian Jakobsen on 30/07/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

enum SessionActionEnum {
    case start
    case renew
    case end
    
    var stringValue: String {
        switch self {
        case .start:
            return "start"
        case .renew:
            return "renew"
        case .end:
            return "end"
        }
    }

}
