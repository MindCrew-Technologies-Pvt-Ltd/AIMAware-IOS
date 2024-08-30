//
//  DataCollectionView.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 21/09/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct MajorMovementSessionView: View {
    let eventService = EventService.shared
    @ObservedObject var settings = PhoneSettings.shared
    
    @State private var hasActiveSession: Bool = false // To track the session status
   
    
    @State private var selectedPositionIndices: (mainIndex: Int, subIndex: Int) = (0, 0)
    @State private var selectedTargetIndices: (mainIndex: Int, subIndex: Int) = (0, 0)
    
    @State private var reportingError = false
    @State private var movementStarted = false
    @State private var newPosition = false
    
    var selectedPosition: (bodyPosition: String, handPosition: String) {
        let bodyPosition = positionOptions[selectedPositionIndices.mainIndex].bodyPosition
        let handPosition = positionOptions[selectedPositionIndices.mainIndex].handPositions[selectedPositionIndices.subIndex]
        return (bodyPosition, handPosition)
    }
    
    var selectedTarget: (targetArea: String, specificTarget: String) {
        let targetArea = targetOptions[selectedTargetIndices.mainIndex].targetArea
        let specificTarget = targetOptions[selectedTargetIndices.mainIndex].specificTargets[selectedTargetIndices.subIndex]
        return (targetArea, specificTarget)
    }
    
    var body: some View {
        VStack {
            if !settings.recordFullSession {
                Text("Turn on recording of full watch sesion in the settings in the phone app").font(.title)
            } else if (!hasActiveSession) {
                NoSessionView()
            } else {
                ActiveSessionView()
            }
        }
        .onAppear {
            // Update hasActiveSession when the view appears
            if let _ = SessionRepo.shared.getActiveSession(deviceType: SharedConstants.watch) {
                self.hasActiveSession = true
            } else {
                self.hasActiveSession = false
            }
        }
    }
    
    private func NoSessionView() -> some View {
        return VStack{
            Text("The watch does not have an active session. Make sure to start one and press the button below.").font(.title).padding(.all, 16)
            Text("It usually takes at most a few seconds from you start the session on the watch until the phone has registered, in rare situation it can take even longer. If you have started the session and it doesn't help to press the button below, you can try to switch to a different app and switch back on the phone and on the watch").padding(.all, 16)
            Button(action: {
                self.hasActiveSession = SessionRepo.shared.getActiveSession(deviceType: SharedConstants.watch) != nil
            }) {
                Text("Done!").font(.title)
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        
    }
    
    
    private func ActiveSessionView() -> some View {
        return NavigationView {
            VStack(alignment: .center) {
                Text("Data collection session")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 16) // Adjust as needed
                    .padding(.leading, 16) // Adjust to match the default navigation bar title's padding
                
                Spacer()
                if (newPosition) {
                    if ( selectedPositionIndices == (0,0) ) {
                        Text("Data collection completed!").font(.title)
                        Text("You can now end the session on the watch.")
                    } else {
                        Text("New position:").font(.title)
                        Text(selectedPosition.bodyPosition) +
                        Text(" and with your hand ") +
                        Text(selectedPosition.handPosition)
                    }
                    
                    Button(action: {
                        newPosition = false
                    }) {
                        Text("Ok!").font(.title)
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                } else if (movementStarted) {
                    (Text("Move your hand to your ") +
                     Text(selectedTarget.specificTarget).foregroundColor(.red) +
                     Text(" and keep it still")).font(.title)
                    
                    Button(action: {
                        self.movementStarted = false
                        self.hasActiveSession = self.createArtificialPositiveEvent()
                        if (self.hasActiveSession) {
                            self.moveToNextSample()
                        }
                    }) {
                        Text("Done!").font(.title)
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                } else {
                    (Text("Get ready in position: ") +
                     Text(selectedPosition.bodyPosition).foregroundColor(selectedTargetIndices == (0,0) && selectedPositionIndices.subIndex == 0 ? .red : .blue ) +
                     Text(" and with your hand ") +
                     Text(selectedPosition.handPosition).foregroundColor(selectedTargetIndices == (0,0) ? .red : .blue )
                    ).font(.title)
                    
                    Button(action: {
                        self.movementStarted = true
                    }) {
                        Text("Ready!").font(.title)
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                Spacer()
                Spacer()
                
                if(movementStarted) {
                    Button(action: {
                        self.moveToNextSample()
                    }) {
                        Text("Skip this target")
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                } else {
                    Button(action: {
                        self.moveToNextPosition()
                        self.resetTarget()
                    }) {
                        Text("Skip this postion")
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                }
                
                Button(action: {
                    self.reportingError = true
                }) {
                    Text("I made a mistake")
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }.sheet(isPresented: $reportingError) {
                    ErrorReportView { errorDescription in
                        // Handle the error description
                        self.createReportError(description: errorDescription)
                    }
                }
                

                
                Spacer()
                
                
                NavigationLink(destination: PositionSelectionView(selectedPositionIndices: $selectedPositionIndices)) {
                    HStack {
                        Text("Position")
                        Spacer()
                        Text(selectedPosition.bodyPosition)
                        + Text(" - ")
                        + Text(selectedPosition.handPosition)
                    }.foregroundColor(Color.white)
                }
                
                NavigationLink(destination: TargetSelectionView(selectedTargetIndices: $selectedTargetIndices)) {
                    HStack {
                        Text("Target")
                        Spacer()
                        Text(selectedTarget.targetArea)
                        + Text(" - ")
                        + Text(selectedTarget.specificTarget)
                    }.foregroundColor(Color.white)
                }
            }
        }
    }
    
    
    private func moveToNextPosition() {
        let currentPositionIndex = selectedPositionIndices
        var mainPositionIndex = currentPositionIndex.mainIndex
        var subPositionIndex = currentPositionIndex.subIndex + 1
        
        if subPositionIndex >= positionOptions[mainPositionIndex].handPositions.count {
            subPositionIndex = 0
            mainPositionIndex = (mainPositionIndex + 1) % positionOptions.count
        }
        
        self.selectedPositionIndices = (mainPositionIndex, subPositionIndex) // not needed?
        newPosition = true
    }
    
    private func resetTarget() {
        self.selectedTargetIndices = (0,0)
    }
    
    private func moveToNextSample() {
        let currentTargetIndex = selectedTargetIndices
        var mainTargetIndex = currentTargetIndex.mainIndex
        var subTargetIndex = currentTargetIndex.subIndex + 1
        
        if subTargetIndex >= targetOptions[mainTargetIndex].specificTargets.count {
            subTargetIndex = 0
            mainTargetIndex = mainTargetIndex + 1
            if mainTargetIndex >= targetOptions.count {
                mainTargetIndex = 0
                moveToNextPosition()
            }
        }
        
        self.selectedTargetIndices = (mainTargetIndex, subTargetIndex)
    }
    
    func createArtificialPositiveEvent() -> Bool {
        return eventService.recordEvent(type: SharedConstants.artificialPositive + "|" +
                                selectedPosition.bodyPosition + "|"  +
                                 selectedPosition.handPosition + "|" +
                                 selectedTarget.targetArea + "|" +
                                 selectedTarget.specificTarget
        )
    }
    
    func createReportError(description: String) {
        print(description)
        _ = eventService.recordEvent(type: SharedConstants.reportedError + "|" + description)
    }
    
}
