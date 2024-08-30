//
//  PrimitiveActiveAlert.swift
//  AImAware WatchKit App
//
//  Created by Sune on 02/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

class PrimitiveActiveAlert : ActiveAlert {
    
    override func updateIsHandStillNearPostion(normalisedMotionData: NormalisedMotionData) {
        //print("primitive active walert")
        if normalisedMotionData.gX < 0.1 {
            self.isHandStillNearPostion = false
        }
    }
}
