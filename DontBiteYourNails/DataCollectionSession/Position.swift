//
//  Positions.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 21/09/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct Position {
    var bodyPosition: String
    var handPositions: [String]
}

let positionOptions: [Position] = [
    
    Position(bodyPosition: "Sitting straight", handPositions: ["on a table/desk", "on a table but near you (arm parallel to edge of table or hand even nearer to edge of table than elbow is)", "in your lap", "on an arm rest", "holding the phone in front of you"]),//5
    Position(bodyPosition: "Sitting leaning forwards", handPositions: ["on a desk"]),//1
    Position(bodyPosition: "Sitting reclined", handPositions: ["in your lap", "on an arm rest", "holding the phone in front of you"]),//3
    Position(bodyPosition: "Standing", handPositions: ["along your side", "on your hip"]),//2
    //Position(bodyPosition: "Walking", handPositions: ["swinging"]),//1
    //Position(bodyPosition: "Lying on back", handPositions: ["along your side", "on your stomach", "on your chest"]),//3
    //Position(bodyPosition: "Lying on non-watch side", handPositions: ["along your side", "next to your head"]),//2
    //Position(bodyPosition: "Lying on stomach", handPositions: ["along your side", "next to your head"]),//2
]


struct PositionSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedPositionIndices: (mainIndex: Int, subIndex: Int) // Make it a binding
    

    var body: some View {
        List {
            ForEach(positionOptions.indices, id: \.self) { mainIndex in
                let mainItem = positionOptions[mainIndex]
                Section(header: Text(mainItem.bodyPosition)) {
                    ForEach(mainItem.handPositions.indices, id: \.self) { subIndex in
                        let handPosition = mainItem.handPositions[subIndex]
                        Button(action: {
                            selectedPositionIndices = (mainIndex: mainIndex, subIndex: subIndex)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Text(handPosition)
                                Spacer()
                                if selectedPositionIndices.mainIndex == mainIndex && selectedPositionIndices.subIndex == subIndex {
                                    Image(systemName: "checkmark") // Use a checkmark for selected item
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Select a Position", displayMode: .inline)
    }
}
