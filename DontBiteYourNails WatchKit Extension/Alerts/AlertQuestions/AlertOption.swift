//
//  AlertOption.swift
//  AImAware
//
//  Created by Sune on 17/12/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation


enum AlertOption : Equatable {
    case boolean(text: String, id: Int)
    case alertEnum(text: String, id: Int)
    
    func optionText() -> String {
        switch self {
        case .boolean(let text, _):
            return text
        case .alertEnum(let text, _):
            return text
        }
    }
    
    func id() -> Int {
        switch self {
        case .boolean(_, let id):
            return id
        case .alertEnum(_, let id):
            return id
        }
    }
    
    static let anxious = AlertOption.alertEnum(text: "Anxious", id: 101)
    static let stressed = AlertOption.alertEnum(text: "Stressed", id: 102)
    static let bored = AlertOption.alertEnum(text: "Bored", id: 103)
    static let frustrated = AlertOption.alertEnum(text: "Frustrated", id: 104)
    static let sad = AlertOption.alertEnum(text: "Sad", id: 105)
    static let tired = AlertOption.alertEnum(text: "Tired", id: 106)
    static let otherFeeling = AlertOption.alertEnum(text: "Other", id: 199)
    
    
    static let workstudy = AlertOption.alertEnum(text: "Work/study", id: 301)
    static let idle = AlertOption.alertEnum(text: "Idle", id: 302)
    static let socialmedia = AlertOption.alertEnum(text: "On social media", id: 303)
    static let otherSituation = AlertOption.alertEnum(text: "Other", id: 399)
    

    
    static let optionTrue = AlertOption.boolean(text: "👍", id: 1)
    static let optionFalse = AlertOption.boolean(text: "👎", id: -1)
    
    /*
    static let leftSideFace = AlertOption.alertEnum(text: "👈", id: 10)
    static let middleFace = AlertOption.alertEnum(text: "Middle", id: 20)
    static let rightSideFace = AlertOption.alertEnum(text: "👉", id: 30)
    
    static let face = AlertOption.alertEnum(text: "Face", id: 1000)
    static let top = AlertOption.alertEnum(text: "Top", id: 3000)
    static let leftSide = AlertOption.alertEnum(text: "👈", id: 2010)
    static let rightSide = AlertOption.alertEnum(text: "👉", id: 2030)
    static let otherMain = AlertOption.alertEnum(text: "Other", id: 9000)
    
    static let forehead = AlertOption.alertEnum(text: "Forehead", id: 1100)
    static let eye = AlertOption.alertEnum(text: "Eye", id: 1200)
    static let nose = AlertOption.alertEnum(text: "Nose", id: 1300)
    static let mouth = AlertOption.alertEnum(text: "Mouth", id: 1400)
    static let chin = AlertOption.alertEnum(text: "Chin", id: 1500)
    static let otherFace = AlertOption.alertEnum(text: "Other", id: 1900)
    
    
    static let hair = AlertOption.alertEnum(text: "Hair", id: 2100)
    static let ear = AlertOption.alertEnum(text: "Ear", id : 2200)
    static let underEar = AlertOption.alertEnum(text: "Under ear", id: 2300)
    static let otherSide = AlertOption.alertEnum(text: "Other", id: 2900)
    
    static let leftTemple = AlertOption.alertEnum(text: "👈 temple", id :3100)
    static let rightTemple = AlertOption.alertEnum(text: "👉 temple", id : 3200)
    static let topSpecific = AlertOption.alertEnum(text: "Top", id: 3300)
    static let otherTop = AlertOption.alertEnum(text: "Other", id: 3900)
    
    
    
    static let neck = AlertOption.alertEnum(text: "Neck", id: 9100)
    static let shoulder = AlertOption.alertEnum(text: "Shoulder", id: 9200)
    static let otherOther = AlertOption.alertEnum(text: "Other", id: 9900)
    
    
    static let handFarFront = AlertOption.alertEnum(text: "In front, near", id: -2000)
    static let handNearFront = AlertOption.alertEnum(text: "In front, far", id: -1000)
    static let otherNegative = AlertOption.alertEnum(text: "Other", id: -9000)
    */
}

