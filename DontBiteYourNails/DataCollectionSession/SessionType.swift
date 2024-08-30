//
//  SessionType.swift
//  AImAware
//
//  Created by Sune on 07/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

enum SessionType: String, CaseIterable, Identifiable {
    case normalUse = "Normal use"
    case naturalRecorded = "Natural movement session"
    case developerSettings = "Developer settings"
    case majorMovement = "Major movement session"
    case minorMovement = "Minor movement session"

    var id: String { self.rawValue }
}
