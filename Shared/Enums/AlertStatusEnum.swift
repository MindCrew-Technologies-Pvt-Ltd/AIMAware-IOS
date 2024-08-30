//
//  AlertStatusEnum.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 30/07/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

enum AlertStatusEnum {
    case confirmed
    case ignored
    case denied
    
    var stringValue: String {
        switch self {
        case .confirmed:
            return "confirmed"
        case .ignored:
            return "ignored"
        case .denied:
            return "denied"
        }
    }

}
