//
//  FireStoreChatConstant.swift
//  AImAware
//
//  Created by Suyog on 22/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

enum signUpTypeName : String {
    case createSignup
    case stateSignup
    case habitSignup
    case subHabitSignup
    case reminderSignup
    case weekendSignup
    case finishSignup
    case completeSignup
}

class FireStoreChatConstant{
    
    static let error = "The password is invalid or the user does not have a password."
    
    //For Habbits
    static let habbits = "Habbits"
    static let users = "users"
    static let name = "Name"
    static let isSelected = "isSelected"
    
    //For StepsToFollow
    static let stepsToFollow = "StepsToFollow"
    
    //For Complete Flow of Signup
    static let userFullName = "FullName"
    static let userEmail = "Email"
    static let userAge = "Age"
    static let userHeight = "Height"
    static let userGender = "Gender"
    static let userCity = "City"
    static let userHabit = "Habit"
    static let userSubHabit = "SubHabit"
    static let userReminder = "Reminder"
    static let userReminderStatus = "ReminderStatus"
    static let userAuthType = "AuthType"
    static let userComes = "Comes"
    static let userWeekendReminder = "WeekendReminder"
    static let userReminderArr = "ReminderData"
    static let completeDataError = "Something went wrong please try again"
    
    //For Setting
    static let userAlertDelayKey = "alertDelayKey"
    static let statsAlertsKey = "status"
    static let statsFirebaseKey = "alerts"
    
}
