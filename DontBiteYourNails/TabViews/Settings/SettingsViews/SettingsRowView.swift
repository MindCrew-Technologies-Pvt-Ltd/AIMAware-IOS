//
//  SettingsRowView.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI


struct SettingsRowView<Control: View>: View {
    var title: String
    var helpText: String?
    var control: Control // The generic control view


    var body: some View {
        VStack(alignment: .leading) {

            BodyText(title).frame(alignment: .leading)
            
            if let helpText = helpText{
                Footnote(helpText).frame(alignment: .leading)
            }
            control.padding(.leading, 12).padding(.trailing, 12)
        }
    }
}

struct SettingsRowToggleView: View {
    var title: String
    var helpText: String?
    @Binding var toggleState: Bool

    init(title: String, helpText: String, toggleState: Binding<Bool>) {
        self.title = title
        self.helpText = helpText
        self._toggleState = toggleState
    }

    // This initializer is used when helpText is nil
    init(title: String, toggleState: Binding<Bool>) {
        self.title = title
        self.helpText = nil
        self._toggleState = toggleState
    }
    
    var body: some View {
        // Use SettingsRowView with a Toggle as the control
        
        HStack {
            VStack(alignment: .leading) {
                
                BodyText(title).frame(alignment: .leading)
                
                if let helpText = helpText{
                    Footnote(helpText).frame(alignment: .leading)
                }
            }
            Spacer()
            Toggle("", isOn: $toggleState).labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Color("TopFadeColor")))
        }.padding(.trailing, 12)

    }
}

