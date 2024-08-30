//
//  View+Extension.swift
//  AImAware
//
//  Created by Maulik Bhuptani on 27/02/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var isDisabled: Bool = false
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(Color("TopFadeColor"))
            .animation(.none, value: 0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color("TopFadeColor"))
            .animation(.none, value: 0)
    }
}

struct CheckmarkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color("FootnoteTextColor"))
            .animation(.none, value: 0)
    }
}
