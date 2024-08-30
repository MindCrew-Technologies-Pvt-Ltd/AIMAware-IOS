//
//  MinorMovementSessionView.swift
//  AImAware
//
//  Created by Sune on 08/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct MinorMovementSessionView: View {
    
    let eventService = EventService.shared
   @State private var hasActiveSession: Bool = false
   
   @State private var startTime: Date?
   @State private var elapsedTime: TimeInterval = 0
   //@State private var movementTotalTime: TimeInterval = 0
   @State private var timer: Timer?
   @State private var recordingsSavedForMovement = 0
   @State private var reportingError = false
   
   @State private var movementList = MinorMovementStructure.trainingList
   @State private var selectedMinorMovementIndices = 0
   
   private let minimumTimePerMovement = 3.0
   
   @State private var previousRecording : (Date, Date)?
    
    
    var body: some View {
        VStack {
            if (!hasActiveSession) {
                NoSessionView()
            } else {
                MinorMovementActiveSessionView()
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
    

    /*@State private var hasActiveSession: Bool = false
    
    var body: some View {
        Group {
            if hasActiveSession {
                // Content for active session
                MinorMovementActiveSessionView(hasActiveSession: $hasActiveSession)
            } else {
                CommonNoSessionView {
                    self.hasActiveSession = SessionRepo.shared.getActiveSession(deviceType: SharedConstants.watch) != nil
                }
            }
        }
    }*/
    private func MinorMovementActiveSessionView() -> some View {
        return Group{
            if (selectedMinorMovementIndices >= movementList.count) {
                HStack{
                    Spacer()
                    Text("\(selectedMinorMovementIndices)/\(movementList.count)")
                }
                Spacer()
                Text("Done!").font(.title)
                Spacer()
                Button(action: {
                    restart()
                }, label: {
                    Text("Restart")
                        .frame(minWidth: 0, maxWidth: 200) // This will make sure the button stretches
                        .padding() // Adds padding around the text
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(Capsule())// Gives rounded corners
                })
                Spacer()
            } else {
                VStack {
                    HStack{
                        Spacer()
                        Text("\(selectedMinorMovementIndices)/\(movementList.count)")
                    }
                    Spacer()
                    Text("Next movement:").font(.title)
                    Text("\(movementList[selectedMinorMovementIndices])").font(.title)
                    Spacer()
                    Button(action: {endPress()}, label: {
                        Text("Press & Hold to make recording")
                            .frame(minWidth: 0, maxWidth: .infinity) // This will make sure the button stretches
                            .padding() // Adds padding around the text
                            .foregroundColor(.white)
                            .background(Color.red)
                            .clipShape(Capsule()) // Gives rounded corners
                    })
                    .padding() // Adds padding around the button
                    .simultaneousGesture(LongPressGesture(minimumDuration: 0.02).onEnded({ _ in
                        startPress()
                    }))
                    
                    
                    Text("\(elapsedTime, specifier: "%.2f") seconds")
                        .font(.title)
                        .foregroundColor(elapsedTime < minimumTimePerMovement ? .red : .green)
                    Text("Recordings: \(recordingsSavedForMovement)")
                        .font(.title)
                        .foregroundColor(recordingsSavedForMovement < 1 ? .red : .green)
                    /*Text("\(movementTotalTime, specifier: "%.2f") seconds")
                     .font(.title)*/
                    
                    HStack{
                        Button(action: {
                            saveRecording()
                        }, label: {
                            Text("Save and stay")
                                .frame(minWidth: 0, maxWidth: 200) // This will make sure the button stretches
                                .padding() // Adds padding around the text
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .clipShape(Capsule())// Gives rounded corners
                        }).disabled(elapsedTime < minimumTimePerMovement)
                            .opacity(elapsedTime < minimumTimePerMovement ? 0.5 : 1.0)
                        
                        Button(action: {
                            saveRecording()
                            nextMovement()
                        }, label: {
                            Text("Save and continue")
                                .frame(minWidth: 0, maxWidth: 200) // This will make sure the button stretches
                                .padding() // Adds padding around the text
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .clipShape(Capsule())// Gives rounded corners
                        }).disabled(elapsedTime < minimumTimePerMovement)
                            .opacity(elapsedTime < minimumTimePerMovement ? 0.5 : 1.0)
                    }
                    
                    HStack{
                        Button(action: {
                            deleteLastRecording()
                        }, label: {
                            Text("Undo recording")
                                .frame(minWidth: 0, maxWidth: 200) // This will make sure the button stretches
                                .padding() // Adds padding around the text
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .clipShape(Capsule())// Gives rounded corners
                            
                        }).disabled(previousRecording == nil)
                            .opacity(previousRecording == nil ? 0.5 : 1.0)
                        
                        Button(action: {
                            nextMovement()
                        }, label: {
                            Text(recordingsSavedForMovement > 0  ? "Go to next movement" : "Skip movement")
                                .frame(minWidth: 0, maxWidth: 200) // This will make sure the button stretches
                                .padding() // Adds padding around the text
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .clipShape(Capsule())// Gives rounded corners
                        })//.disabled(!recordingSavedForMovement)
                        //.opacity(!recordingSavedForMovement ? 0.5 : 1.0)
                    }
                    Spacer()
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
                }
            }
        }
    }

    
    func startPress() {
        if(previousRecording != nil) {
            saveRecording()
        }
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if let startTime = self.startTime {
                self.elapsedTime = Date().timeIntervalSince(startTime)
            }
        }
    }

    func endPress() {
        print("endPress")
        let endTime = Date()
        elapsedTime = endTime.timeIntervalSince(startTime!)
        previousRecording = (startTime!, endTime)
        //movementTotalTime = movementTotalTime + elapsedTime
        startTime = nil
        
        timer?.invalidate()
        timer = nil
    }
    
    func nextMovement() {
        previousRecording = nil
        startTime = nil
        elapsedTime = 0
        //movementTotalTime = 0
        recordingsSavedForMovement = 0
        moveToNextSample()
    }
    
    func deleteLastRecording() {
        previousRecording = nil
        startTime = nil
        //movementTotalTime = movementTotalTime - elapsedTime
        elapsedTime = 0
    }
    
    func saveRecording() {
        if (elapsedTime >= minimumTimePerMovement) {
            self.hasActiveSession = createArtificialPositiveEvent()
            recordingsSavedForMovement += 1
        }
        deleteLastRecording()
    }
    
    func createReportError(description: String) {
        print(description)
        _ = eventService.recordEvent(type: SharedConstants.reportedError + "|" + description)
    }
    
    private func moveToNextSample() {
        saveRecording()
        selectedMinorMovementIndices = selectedMinorMovementIndices + 1
    }

    private func restart() {
        selectedMinorMovementIndices = 0
    }

    private func goBack() {
        deleteLastRecording()
        recordingsSavedForMovement = 0
        selectedMinorMovementIndices = selectedMinorMovementIndices - 1
    }
    
    func createArtificialPositiveEvent() -> Bool {
        if let previousRecording = self.previousRecording {
            let startInterval = previousRecording.0.timeIntervalSinceReferenceDate
            let endInterval = previousRecording.1.timeIntervalSinceReferenceDate

            return eventService.recordEvent(type: SharedConstants.dataEpisode + "|" +
                                            "\(startInterval)" + "|" +
                                            "\(endInterval)" + "|" +
                                            SharedConstants.minorMovementEvent + "|" +
                                            movementList[selectedMinorMovementIndices]
                                            
            )
        } else {
            return eventService.recordEvent(type: SharedConstants.dataEpisode + "|" +
                                            "Failed, shouldn't happen"
            )
        }
    }
}
