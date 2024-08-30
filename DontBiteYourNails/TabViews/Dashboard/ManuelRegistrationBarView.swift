//
//  ManuelRegistrationBarView.swift
//  AImAware
//
//  Created by Sune on 14/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct ManuelRegistrationBarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        HStack {
            BodyText("Manually register an event")
                .padding(20)
            Spacer()
            
            Button(action: {
                // Your action here
            }) {
                Text("Register")
                    .foregroundColor(.white) // Set text color
                    .fontWeight(.medium)
                    .padding(8)// Set padding
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .background(Color("TopFadeColor")) // Set background color
                    .cornerRadius(8)       // Optional: to make the corners rounded
                    .padding(15)
            }
        }
        .background(LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color("LeftFadeColor"), location: 0.1),
                .init(color: Color("RightFadeColor"), location: 0.9)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        ))
        .cornerRadius(20)
        .padding(25)
    }
}
