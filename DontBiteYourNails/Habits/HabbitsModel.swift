//
//  HabbitsModel.swift
//  AImAware
//
//  Created by Suyog on 22/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
struct HabbitModel: Codable {
    //var image: String?
    var name: String?
}
extension HabbitModel {
    init(_ dict: [String: Any]) {
        print(dict)
        self.name = dict.getStringValue(forkey: FireStoreChatConstant.name)
    }
}


