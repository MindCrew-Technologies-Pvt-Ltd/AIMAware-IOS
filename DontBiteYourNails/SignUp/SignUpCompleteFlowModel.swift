//
//  SignUpCompleteFlowModel.swift
//  AImAware
//
//  Created by Suyuog on 25/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
struct SignUpCompleteFlowModel: Codable {
    var useFullName: String?
    var userEmail: String?
    var userAge: String?
    var userHeight: String?
    var userGender: String?
    var userCity: String?
    var userHabit: String?
    var userSubHabit: String?
    var userReminder: TimeInterval?
    var userComes: String?
    var userAuthType: String?
    var userWeekendReminder: [String]?
}
extension SignUpCompleteFlowModel {
    init(_ dict: [String: Any]) {
        print(dict)
        self.useFullName = dict.getStringValue(forkey: FireStoreChatConstant.userFullName)
        self.userEmail = dict.getStringValue(forkey: FireStoreChatConstant.userEmail)
        self.userAge = dict.getStringValue(forkey: FireStoreChatConstant.userAge)
        self.userHeight = dict.getStringValue(forkey: FireStoreChatConstant.userHeight)
        self.userGender = dict.getStringValue(forkey: FireStoreChatConstant.userGender)
        self.userCity = dict.getStringValue(forkey: FireStoreChatConstant.userCity)
        self.userHabit = dict.getStringValue(forkey: FireStoreChatConstant.userHabit)
        self.userSubHabit = dict.getStringValue(forkey: FireStoreChatConstant.userSubHabit)
        self.userReminder = dict.getTimeIntervalValue(forkey: FireStoreChatConstant.userReminder)
        self.userAuthType = dict.getStringValue(forkey: FireStoreChatConstant.userAuthType)
        self.userWeekendReminder = dict.getArrayStringValue(forkey: FireStoreChatConstant.userWeekendReminder)
    }
}
