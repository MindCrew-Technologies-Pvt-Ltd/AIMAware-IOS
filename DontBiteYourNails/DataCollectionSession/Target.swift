//
//  TouchTarget.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 21/09/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct Target {
    var targetArea: String
    var specificTargets: [String]
}


let targetOptions: [Target] = [
    Target(targetArea: "Face", specificTargets: ["left eyebrow", "left eye", "right eyebrow", "right eye", "nose", "mouth with your thumb", "mouth with your index finger", "mouth with your little finger", "upper left cheek", "lower left cheek/jaw", "upper right cheek", "lower right cheek/jaw"]),//12
    Target(targetArea: "Left side", specificTargets: ["left ear, inside", "left ear, outside", "left earlobe", "hair above and in front of left ear", "hair above left ear", "hair behind and above left ear", "neck, behind left ear"]),//7
    Target(targetArea: "Right side", specificTargets: ["right ear, inside", "right ear, outside", "right earlobe", "hair above and in front of right ear", "hair above right ear", "hair behind and above right ear", "neck, behind right ear"]),//7
    Target(targetArea: "Top of head", specificTargets: ["left temple", "right temple", "front hair", "hair, in front of top", "hair top", "hair, behind top"]),//6
    Target(targetArea: "Left back", specificTargets: ["left shoulder", "neck from left side", "upper back from left side"]),//3
    Target(targetArea: "Right back", specificTargets: ["right shoulder", "neck from right side", "upper back from right side"])//3
]


struct TargetSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedTargetIndices: (mainIndex: Int, subIndex: Int)

    var body: some View {
        List {
            ForEach(targetOptions.indices, id: \.self) { mainIndex in
                let mainItem = targetOptions[mainIndex]
                Section(header: Text(mainItem.targetArea)) {
                    ForEach(mainItem.specificTargets.indices, id: \.self) { subIndex in
                        let specificTarget = mainItem.specificTargets[subIndex]
                        Button(action: {
                            selectedTargetIndices = (mainIndex: mainIndex, subIndex: subIndex)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Text(specificTarget)
                                Spacer()
                                if selectedTargetIndices.mainIndex == mainIndex && selectedTargetIndices.subIndex == subIndex {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Select a Target", displayMode: .inline)
    }
}
