//
//  AlertQuestions.swift
//  DontBiteYourNails WatchKit Extension
//
//  Created by Sune Kristian Jakobsen on 31/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation


enum AlertQuestion {
    case singleChoiceQuestion(text: String, options: [[AlertOption]], id: Int)
    //case optionNodeHierarchyQuestion(text: String, optionNodeHierarchy: OptionNodeHierarchy,id: Int)
    case integerQuestion(text: String, min: Int, max: Int, id: Int)
    
    func questionText() -> String {
        switch self {
        case .singleChoiceQuestion(let text, _, _):
            return text
        /*case .optionNodeHierarchyQuestion(let text, _, _):
            return text*/
        case .integerQuestion(let text, _, _, _):
            return text
        }
    }
    
    func answerOptions() -> [[AlertOption]] {
        switch self {
        case .singleChoiceQuestion(_, let options, _):
            return options
        default:
            return []
        }
    }
    /*
    func answerOptionHierarchy() -> OptionNodeHierarchy? {
        switch self {
        case .optionNodeHierarchyQuestion(_, let optionHierarchy, _):
            return optionHierarchy
        default:
            return nil
        }
    }*/
    
    
    func id() -> Int {
        switch self {
        case .singleChoiceQuestion(_, _, let id):
            return id
        /*case .optionNodeHierarchyQuestion(_, _,let id):
            return id*/
        case .integerQuestion(_, _, _, let id):
            return id
        }
    }
    
    static let urgeIntensity = AlertQuestion.integerQuestion(
        text: "How strong is the urge", min: 1, max: 10, id: SharedConstants.urgeQuestionId)
    
    static let feeling = AlertQuestion.singleChoiceQuestion(
        text: "How were you feeling?",
        options: [[AlertOption.anxious],
                  [AlertOption.stressed],
                  [AlertOption.bored],
                  [AlertOption.frustrated],
                  [AlertOption.sad],
                  [AlertOption.tired],
                  [AlertOption.otherFeeling]],
        id: SharedConstants.feelingQuestionId
    )
    
    static let situation = AlertQuestion.singleChoiceQuestion(
        text: "What are you up to?",
        options: [[AlertOption.workstudy],
                  [AlertOption.idle],
                  [AlertOption.socialmedia],
                  [AlertOption.otherSituation]],
        id: SharedConstants.situationQuestionId
    )
    
    static let correctness = AlertQuestion.singleChoiceQuestion(
        text: "Correct alert?",
        options: [[AlertOption.optionTrue, AlertOption.optionFalse]],
        id: SharedConstants.correctQuestionId
    )
    
    static let shouldHaveAlert = AlertQuestion.singleChoiceQuestion(
        text: "Should there have been an alert?",
        options: [[AlertOption.optionTrue, AlertOption.optionFalse]],
        id: 0
    )
    
    /*static let minorMovement = AlertQuestion.optionNodeHierarchyQuestion(
        text: "Select minor movement",
        optionNodeHierarchy: MinorMovementStructure().rootNode,
        id: 111
    )*/
    
    static let dataQuality = AlertQuestion.singleChoiceQuestion(
        text: "Good data and stable orientation?",
        options: [[AlertOption.optionTrue, AlertOption.optionFalse]],
        id: 1
    )
    
    /*
    static let broadPositiveCategory = AlertQuestion.singleChoiceQuestion(
        text: "Where?",
        options: [[AlertOption.face,
                  AlertOption.top],
                  [AlertOption.leftSide,
                  AlertOption.rightSide],
                  [AlertOption.otherMain]],
        id: 2
        
    )
    
    
    static let whichSide = AlertQuestion.singleChoiceQuestion(
        text: "Which side?",
        options: [[AlertOption.leftSideFace,
                  AlertOption.rightSideFace
                 ]],
        id: 3
    )
    
    
    static let whichSideOrMiddle = AlertQuestion.singleChoiceQuestion(
        text: "Which side?",
        options: [[AlertOption.leftSideFace,
                  AlertOption.rightSideFace],
                  [AlertOption.middleFace]],
        id: 4
    )
    
    static let faceArea = AlertQuestion.singleChoiceQuestion(
        text: "Where?",
        options: [[AlertOption.forehead],
                  [AlertOption.eye,
                  AlertOption.nose],
                  [AlertOption.mouth,
                  AlertOption.chin],
                  [AlertOption.otherFace]],
        id: 1000
    )
    
    static let topArea = AlertQuestion.singleChoiceQuestion(
        text: "Where?",
        options: [
            [AlertOption.leftTemple,
            AlertOption.rightTemple],
            [AlertOption.topSpecific,
            AlertOption.otherTop]],
        id: 2000
    )
    
    static let sideArea = AlertQuestion.singleChoiceQuestion(
        text: "Where?",
        options: [[AlertOption.hair,
                  AlertOption.ear],
                  [AlertOption.underEar,
                  AlertOption.otherSide]],
        id: 3000
    )
    
    static let otherArea = AlertQuestion.singleChoiceQuestion(
        text: "Where?",
        options: [[AlertOption.neck],
                  [AlertOption.shoulder],
                  [AlertOption.otherOther]],
        id: 99000
    )
    
    static let falseCategories = AlertQuestion.singleChoiceQuestion(
        text: "Where?",
        options: [[AlertOption.handNearFront],
                  [AlertOption.handFarFront],
                  [AlertOption.otherNegative]],
        id: -10000
    )*/
}
