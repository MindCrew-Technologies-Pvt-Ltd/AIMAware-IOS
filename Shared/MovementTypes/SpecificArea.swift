//
//  SpecificAreas.swift
//  DontBiteYourNails
//
//  Created by Sune on 27/10/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

struct SpecificArea: Hashable {
    let code: Int
    
    static let allValues: [String] = ["None", "Front hair", "Hair above opposite side ear",
                                      "Hair above watch side ear",
                                      "Hair behind and above opposite side ear",
                                      "Hair behind and above watch side ear", "hair top",
                                      "Hair, behind top", "Hair, in front of top",
                                      "Lower opposite side cheek/jaw", "Lower watch side cheek/jaw",
                                      "Mouth", "Neck opposite side", "Neck watch side",
                                      "Opposite side ear", "Opposite side eye",
                                      "Opposite side temple", "Opposite side upper back",
                                      "Watch side ear", "Watch side eye", "Watch side temple",
                                      "Watch side upper back", "Nose", "Opposite side earlobe",
                                      "Upper opposite side cheek", "Upper watch side cheek",
                                      "Watch side earlobe"]
    
    static let stringToInt: [String: Int] = {
        var map = [String: Int]()
        for (index, value) in allValues.enumerated() {
            map[value] = index
        }
        return map
    }()
    
    static let intToString: [Int: String] = {
        var map = [Int: String]()
        for (index, value) in allValues.enumerated() {
            map[index] = value
        }
        return map
    }()
    
    var stringValue: String? {
        return SpecificArea.intToString[code]
    }
    
    static func from(string: String) -> SpecificArea? {
        if let value = stringToInt[string] {
            return SpecificArea(code: value)
        }
        return nil
    }
}
