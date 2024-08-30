//
//  ExportableMotionData.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 20/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

struct ExportableMotionData : Encodable {
    
    var dataArray : [NormalisedMotionData]
    
    init(from: String) {
        self.dataArray = from.split(separator: "|")
            .map { String($0) }
            .filter{ $0 != ""}
            .map {NormalisedMotionData(from: $0)}
    }
    
}
