//
//  AlertView.swift
//  DontBiteYourNails WatchKit Extension
//
//  Created by Sune Kristian Jakobsen on 29/07/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct AlertView: View {
    
    @ObservedObject private var settings = WatchSettings.shared
    @State private var isShowQuestions = false
    @State private var isAlertDelayClicked = false
    var resetHostingController: () -> Void
    @EnvironmentObject var activateAlertService: ActivateAlertService

    var body: some View {
        QuestionView
       /* if settings.isProd {
            QuestionView
        } else {
            ScrollView {
                SpecificAreaView
            }
        }*/
       
    }
    

    /*
    var SpecificAreaView: some View {
        let specificAreaOrderedArray = activateAlertService.activeAlert?.specificAreaDictionary
        if specificAreaOrderedArray != nil {
            return AnyView(renderSpecificAreaView(specificAreaOrderedArray!))
        } else {
            return AnyView(Text("Error no question"))
        }
    }
    
    private func renderSpecificAreaView(_ specificAreaOrderedArray: [(String, Double)]) -> some View {
        Group {
            VStack {
                Button("Hand not near head") {
                    activateAlertService.appendSpecificArea(specificArea: SpecificArea(code: 0))
                    resetHostingController()
                }
                Spacer()
            //HStack {
                ForEach(specificAreaOrderedArray, id: \.self.0) { answerOption in
                    Button(answerOption.0 + ": " + String(answerOption.1)) {
                        activateAlertService.appendSpecificArea(specificArea: SpecificArea.from(string: answerOption.0)!)
                        resetHostingController()
                    }
                    Spacer()
                }
                
            }

        }//.id(activateAlertService.nextQuestion?.id())
    }*/
    
    @ViewBuilder
    var QuestionView: some View {
        if let alertQuestion = activateAlertService.nextQuestion {
            
            questionView(for: alertQuestion).id(activateAlertService.nextQuestion?.id())
        } else {
            Text("Error no question")
        }
    }
        
    @ViewBuilder
    func questionView(for question: AlertQuestion) -> some View { // Replace QuestionType with your actual type
        switch question {
        case .singleChoiceQuestion(_, _, _):
            SingleChoiceQuestionView(alertQuestion : question)
        /*case .optionNodeHierarchyQuestion(text: _, let optionNodeHierarchy, id: _):
            OptionNodeHierarchyView(currentNode: optionNodeHierarchy, activateAlertService: activateAlertService)*/
        case .integerQuestion(let text, let min, let max, let id):
            IntegerQuestionView(text: text, min: min, max: max, id: id)
        }
    }
    
     //@State private var currentOptions: [OptionNodeHierarchy] = []

     // Instance of your hierarchy
     //let hierarchy = MinorMovementStructure().rootNode

    func SingleChoiceQuestionView(alertQuestion: AlertQuestion) -> some View {
        Group {
            GeometryReader { geometry in
                ScrollView{
                    VStack {
                        Spacer(minLength: 0)
                        Text(alertQuestion.questionText())
                        ForEach(0..<alertQuestion.answerOptions().count, id: \.self) { rowIndex in
                            HStack {
                                ForEach(0..<alertQuestion.answerOptions()[rowIndex].count, id: \.self) { optionIndex in
                                    let answerOption = alertQuestion.answerOptions()[rowIndex][optionIndex]
                                    Button(answerOption.optionText()) {
                                        isAlertDelayClicked = true
                                        activateAlertService.appendAnswer(questionId: alertQuestion.id(), answer: answerOption.optionText())
                                        resetHostingController()
                                    }
                                }
                                Spacer()
                                
                            }
                        }
                        Spacer(minLength: 0)
                    }
                    
                    .frame(minWidth: geometry.size.width)
                    // Use .frame to attempt to center content vertically when it doesn't fill the screen
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
    }
    
    @State private var selectedNumber = 1
    func IntegerQuestionView(text: String, min: Int, max: Int, id: Int) -> some View {
        
        return Group {
                    VStack {
                        Text(text)
                        Picker(selection: $selectedNumber, label: Text("Numbers").hidden()) {
                            // Assuming you have a method to get the range from alertQuestion
                            ForEach(min...max, id: \.self) { number in
                                Text("\(number)").tag(number)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 40)
                        Button(action: {
                            continueButtonPressed()
                        }) {
                            Text("Continue")
                        }
                    }
        }
        
        func continueButtonPressed() {
            // Send the answer using the activateAlertService
            activateAlertService.appendAnswer(questionId: id, answer: String(selectedNumber))
            // Reset the hosting controller
            resetHostingController()
        }

    }
    

    /*
    func SingleChoiceQuestionView(alertQuestion: AlertQuestion) -> some View {
        Group {
            VStack {
                Text(alertQuestion.questionText())
                ForEach(0..<alertQuestion.answerOptions().count, id: \.self) { rowIndex in
                    HStack {
                        ForEach(0..<alertQuestion.answerOptions()[rowIndex].count, id: \.self) { optionIndex in
                            let answerOption = alertQuestion.answerOptions()[rowIndex][optionIndex]
                            Button(answerOption.optionText()) {
                                activateAlertService.appendAnswer(answer: answerOption.optionText())
                                resetHostingController()
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
    }*/

}


/*
struct OptionNodeHierarchyView: View {
    @State var currentNode: OptionNodeHierarchy?
    @State var currentOptions: [OptionNodeHierarchy] = []
    var activateAlertService: ActivateAlertService
    
    var body: some View {
        VStack {
            if let currentNode = currentNode {
                selectionView(node: currentNode)
            } else {
                Text("Error, no current node (no question)")
            }
        }
    }
    
    func selectionView(node: OptionNodeHierarchy) -> some View {
        List(node.children, id: \.id) { option in
            Button(action: {
                if option.children.isEmpty {
                    activateAlertService.appendAnswer(questionId: 0, answer: option.fullName)//to fix, if we are using question hierarchy again we need to set the id correctly
                } else {
                    currentNode = option // Move to next node
                    currentOptions = option.children
                }
            }) {
                Text(option.value)
            }
        }.id(UUID())
    }
}
*/
