//
//  StepToFollowModel.swift
//  AImAware
//
//  Created by Suyog on 22/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
struct StepsToFollowModel: Codable {
    //var image: String?
    var name: String?
    var isSelected : Bool?
}
extension StepsToFollowModel {
    init(_ dict: [String: Any]) {
        print(dict)
        self.name = dict.getStringValue(forkey: FireStoreChatConstant.name)
        self.isSelected = dict.getBoolValue(forkey: FireStoreChatConstant.isSelected)
    }
}


enum StepFollowName : String {
    case playName = "Click the play button. When the app runs, it should change to reload"
    case installationName = "Make sure the app is installed on your watch app"
    case phoneName = "Install the app on your phone"
    case watchName = "Open AImAware on your watch"
    case statsName = "You’ll find the statistics of use your phone app stats tab"
    case approachName = "Approach your watch to the face. It should vibrate; if not, check your watch settings"
    case questionName = "Answer the questions prompted in the app"
}



