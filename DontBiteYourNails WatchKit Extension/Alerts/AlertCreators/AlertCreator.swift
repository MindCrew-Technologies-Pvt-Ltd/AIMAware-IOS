//
//  MotionModelGuard.swift
//  AImAware WatchKit App
//
//  Created by Sune on 02/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

protocol AlertCreator: AnyObject {
    func addElement(normalisedMotionData: NormalisedMotionData) // should only be called if out layer has already decided that now alert should be triggered
    func addElementAndMakeDecision(normalisedMotionData: NormalisedMotionData) -> ActiveAlert?
}
