//
//  RecordingService.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 07/09/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import CoreMotion
import CoreData

class PhoneRecordingService : ObservableObject {
    static var shared = PhoneRecordingService()
    
    let settings = PhoneSettings.shared
    let config = Config.shared
    let sessionRepo = SessionRepo.shared
    let sessionMotionDataRepo = SessionMotionDataRepo.shared
    let motion = CMMotionManager()
    let persistentContainer = CoreDataManager.shared.persistentContainer
    
    private var motionData: [NormalisedMotionData] = []
    
    var timer: Timer?
    var sessionUUID : UUID?
    
    @Published var isRecording: Bool = false
    
    func startTimer() {
        self.stopTimerWithoutSettingIsRecording()
        DispatchQueue.main.async{
            self.isRecording = true
            print("isRecording set to true")
        }
        
        if self.motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / self.config.updateFrequency
            self.motion.showsDeviceMovementDisplay = true
            
            //DispatchQueue.main.asyncAfter(deadline: nextExecutionDispatch()) {// inserting delay in case we need to sync with other devices
                self.motion.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical)
                
                self.createSessionInDatabase()
                
                self.timer = Timer(fire: nextExecutionDispatch(), interval: 1.0 / self.config.updateFrequency, repeats: true,
                                   block: {_ in self.recording(motionmanager: self.motion)
                    
                })
                
                RunLoop.main.add(self.timer!, forMode: .default)
            //}
        }
    }
    
    func stopTimer() {
        stopTimerWithoutSettingIsRecording()
        flush()
        endSessionInDatabase()
        DispatchQueue.main.async{
            self.isRecording = false
            self.sessionUUID = nil
            print("isRecording set to false")
        }
    }
    
    fileprivate func stopTimerWithoutSettingIsRecording() {
        self.timer?.invalidate()
        self.timer = nil
        print("Recording stopped")
    }
    
    
    func recording(motionmanager: CMMotionManager) {
        
        if let data = motionmanager.deviceMotion {
            let normalisedData = NormalisedMotionData(motionData: data)
            
            motionData.append(normalisedData)
            //print("Number of datapoints: \(motionData.count)")
            if (motionData.count >= 75) {// flushing at the same size as for watch sessions. Not sure if it make sense to have bigger or smaller chunks.
                //print("Above 10")
                flush()
            }

        } else {
            print("Missing data")
        }
    }
    
    func flush() {
        if motionData.count > 0 {
            // store the data
            var normalisedMotionDataString = ""
            for datapoint in motionData {
                normalisedMotionDataString += datapoint.toString() + "|"
            }
            resetMovementData()
            
            if let uuidString = self.sessionUUID?.uuidString {
                sessionMotionDataRepo.addSessionMotionData(persistentContainer, Date(), uuidString, normalisedMotionDataString)
                print("Data saved on phone motion data session")
            } else {
                print("Could not save data on session due to problem with uuid")
            }
            
        }
    }
    
    fileprivate func resetMovementData() {
        motionData = []
    }
    
 
    func createSessionInDatabase() {
        sessionRepo.endUnendedSessions(persistentContainer : persistentContainer, deviceType: SharedConstants.phone, deviceId: "phone")
        
        self.sessionUUID = UUID()
        sessionRepo.createSession(persistentContainer, Date(), sessionUUID?.uuidString ?? "", nil, deviceType: SharedConstants.phone, deviceId: "phone")
    }
    
    func endSessionInDatabase() {
        if let uuidString = self.sessionUUID?.uuidString {
            sessionRepo.endSessionNow(id: uuidString)
        }
    }
    
    func nextExecutionDispatch() -> Date {
        let currentTime = Date().timeIntervalSinceReferenceDate
    
        let numberOfPeriods = currentTime * config.updateFrequency
        var nextExecutionTime = (floor(numberOfPeriods) + 0.85)/config.updateFrequency
        if (nextExecutionTime < currentTime) {
            nextExecutionTime = nextExecutionTime + 1.0/config.updateFrequency
        }
        print("nextExecutionTime: \(nextExecutionTime)")
        return Date(timeIntervalSinceReferenceDate: nextExecutionTime)
        //let delay = nextExecutionTime - currentTime
        //print("delay: \(delay)")
        //return .now() + delay
    }
}
