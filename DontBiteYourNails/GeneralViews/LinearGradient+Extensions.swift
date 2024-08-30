//
//  LinearGradient+Extensions.swift
//  AImAware
//
//  Created by Sune on 08/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//


import SwiftUI

extension LinearGradient {
    static func customGradient(endPoint: UnitPoint) -> LinearGradient {
        let startPoint: UnitPoint
        switch endPoint {
        case .bottom:
            startPoint = .top
        case .top:
            startPoint = .bottom
        case .leading:
            startPoint = .trailing
        case .trailing:
            startPoint = .leading
        // Add more cases if needed
        default:
            startPoint = .top // default or opposite of your choice
        }

        return LinearGradient(
            gradient: Gradient(colors: [Color("TopFadeColor"), Color("MiddleFadeColor"), Color("ButtomFadeColor")]),
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
}
