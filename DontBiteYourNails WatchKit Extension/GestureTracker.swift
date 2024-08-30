//
//  GestureTracker.swift
//  DontBiteYourNails WatchKit Extension
//
//  Created by Sune Kristian Jakobsen on 26/09/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import CoreML
import SwiftUI

struct GestureTracker {
    let watchSettings = WatchSettings.shared
    let config = Config.shared
    let watchPhoneConnector = WatchPhoneConnector.shared
    let appSessionService = AppSessionService.shared
    
    var rnnModel: Rnn?
    var specificAreaModel: SpecificAreaModel?
    
    private var accelX: CircularBuffer
    private var accelY: CircularBuffer
    private var accelZ: CircularBuffer
    private var rotationX: CircularBuffer
    private var rotationY: CircularBuffer
    private var rotationZ: CircularBuffer
    private var gX: CircularBuffer
    private var gY: CircularBuffer
    private var gZ: CircularBuffer
    
    private var episodeLength = 0.0
    private var isClear = true
    
    init() {
        accelX = CircularBuffer(size: config.episodeLength)
        accelY = CircularBuffer(size: config.episodeLength)
        accelZ = CircularBuffer(size: config.episodeLength)
        rotationX = CircularBuffer(size: config.episodeLength)
        rotationY = CircularBuffer(size: config.episodeLength)
        rotationZ = CircularBuffer(size: config.episodeLength)
        gX = CircularBuffer(size: config.episodeLength)
        gY = CircularBuffer(size: config.episodeLength)
        gZ = CircularBuffer(size: config.episodeLength)
        
        do {
            self.rnnModel = try Rnn()
            self.specificAreaModel = try SpecificAreaModel()
        } catch {
            // Handle error
            print("Couldn't load the model")
        }

    }
    
    mutating func addDataPoint(motionData: NormalisedMotionData) {
        self.episodeLength += 1
        self.accelX.addElement(motionData.accelX)
        self.accelY.addElement(motionData.accelY)
        self.accelZ.addElement(motionData.accelZ)
        self.rotationX.addElement(motionData.rotationX)
        self.rotationY.addElement(motionData.rotationY)
        self.rotationZ.addElement(motionData.rotationZ)
        self.gX.addElement(motionData.gX)
        self.gY.addElement(motionData.gY)
        self.gZ.addElement(motionData.gZ)
        self.isClear = false
    }
    
    func hasOngoingGesture() -> Bool {
        return !isClear
    }
    
    func getEpisodeLength() -> Double {
        return episodeLength
    }
    
    mutating func clear() {
        self.episodeLength = 0
        self.accelX.clear()
        self.accelY.clear()
        self.accelZ.clear()
        self.rotationX.clear()
        self.rotationY.clear()
        self.rotationZ.clear()
        self.gX.clear()
        self.gY.clear()
        self.gZ.clear()
        self.isClear = true
    }
    
    
    func whichMovementToHead() -> (Bool, [String: Double]) {
        if episodeLength <= 21 {
            return (false, [:])
        }
        
        let inputData = calculateInputData()
        
        let wasMovementToHead = rnnWasMovementToHead(movementData: inputData)
        
        if !wasMovementToHead {
            return (false, [:])
        } else {
            return (true, specificAreaDictionary(movementData: inputData))
        }

    }
    
    fileprivate func calculateInputData() -> MLMultiArray {
        guard let inputData = try? MLMultiArray(shape: [1, 50, 9], dataType: .float32) else {
            sendErrorToIphone(message: "Unexpected runtime error. MLMultiArray")
            fatalError("")
        }
        
        let rotationXArray = rotationX.getPaddedElements()
        let rotationYArray = rotationY.getPaddedElements()
        let rotationZArray = rotationZ.getPaddedElements()
        let accelXArray = accelX.getPaddedElements()
        let accelYArray = accelY.getPaddedElements()
        let accelZArray = accelZ.getPaddedElements()
        let gXArray = gX.getPaddedElements()
        let gYArray = gY.getPaddedElements()
        let gZArray = gZ.getPaddedElements()
        
        for i in 0..<50 {
            inputData[i * 9 + 0] = NSNumber(value: normalizeRotation(rawValue: rotationXArray[i]))
            inputData[i * 9 + 1] = NSNumber(value: normalizeRotation(rawValue: rotationYArray[i]))
            inputData[i * 9 + 2] = NSNumber(value: normalizeRotation(rawValue: rotationZArray[i]))
            inputData[i * 9 + 3] = NSNumber(value: normalizeAccel(rawValue: accelXArray[i]))
            inputData[i * 9 + 4] = NSNumber(value: normalizeAccel(rawValue: accelYArray[i]))
            inputData[i * 9 + 5] = NSNumber(value: normalizeAccel(rawValue: accelZArray[i]))
            inputData[i * 9 + 6] = NSNumber(value: gXArray[i])
            inputData[i * 9 + 7] = NSNumber(value: gYArray[i])
            inputData[i * 9 + 8] = NSNumber(value: gZArray[i])
        }
        
        return inputData
    }
    
    
    fileprivate func specificAreaDictionary(movementData: MLMultiArray) -> [String: Double] {
        var timearray: [(String, Double)]  = []
        timearray.append(("before", Date().timeIntervalSinceReferenceDate))
        
        let input = SpecificAreaModelInput(input_12: movementData)
        
        timearray.append(("Input created", Date().timeIntervalSinceReferenceDate))
        
        // Perform the prediction
        guard let output = try? self.specificAreaModel?.prediction(input: input) else {
            sendErrorToIphone(message: "Unexpected runtime error. Prediction")
            fatalError("")
        }
        
        timearray.append(("specific area called", Date().timeIntervalSinceReferenceDate))
        
        var areaProbablityDict: [String: Double] = [:]

        if SpecificArea.allValues.count == output.Identity.count {
            for i in 0..<SpecificArea.allValues.count {
                let key = SpecificArea(code:i)
                let value = output.Identity[i].doubleValue // Assuming output.Identity is MLMultiArray
                areaProbablityDict[key.stringValue ?? ""] = value
            }
        } else {
            print("Both arrays should have the same length.")
        }
        
        if (config.sendMLcallsToPhone) {
            sendMlCallToIphone(input : movementData, output: multiArrayToArray(multiArray: output.Identity), modelType: SharedConstants.specificArea, timeArray: timearray)
        }

        return areaProbablityDict
    }
    
    fileprivate func rnnWasMovementToHead(movementData: MLMultiArray) -> Bool {
        var timearray: [(String, Double)]  = []
        timearray.append(("before", Date().timeIntervalSinceReferenceDate))
        
        let input = RnnInput(conv1d_197_input: movementData)
        
        timearray.append(("Input created", Date().timeIntervalSinceReferenceDate))
        
        // Perform the prediction
        guard let output = try? self.rnnModel?.prediction(input: input) else {
            sendErrorToIphone(message: "Unexpected runtime error. Prediction")
            fatalError("")
        }
        
        timearray.append(("rnn called", Date().timeIntervalSinceReferenceDate))
        
        let floatOutput = output.Identity[0].floatValue

        timearray.append(("float output created", Date().timeIntervalSinceReferenceDate))
        
        if (config.sendMLcallsToPhone) {
            print("Output: \(floatOutput)")
            sendMlCallToIphone(input : movementData, output: multiArrayToArray(multiArray: output.Identity), modelType: SharedConstants.rnn, timeArray: timearray)
        }
        
        //print3DMLMultiArray(array: inputData)
        return floatOutput > 0.5
    }
    
    func normalizeRotation(rawValue: Double) -> Double {
        return rawValue / 3.73
    }
    
    func normalizeAccel(rawValue: Double) -> Double {
        return rawValue * 3.312 / watchSettings.safeUserHeight
    }
    
    // for debug only
    func printMLMultiArray(array: MLMultiArray) {
        let pointer = array.dataPointer.assumingMemoryBound(to: Double.self)
        let rowCount = array.shape[0].intValue
        let colCount = array.shape[1].intValue
        for i in 0..<rowCount {
            for j in 0..<colCount {
                let value = pointer[i * colCount + j]
                print(value, terminator: " ")
            }
            print("")
        }
    }
    
    // for debug only
    func print3DMLMultiArray(array: MLMultiArray) {
        let pointer = array.dataPointer.assumingMemoryBound(to: Float.self)
        let shape0 = array.shape[0].intValue
        let shape1 = array.shape[1].intValue
        let shape2 = array.shape[2].intValue
        
        for i in 0..<shape0 {
            for j in 0..<shape1 {
                for k in 0..<shape2 {
                    let offset = i * shape1 * shape2 + j * shape2 + k
                    let value = pointer[offset]
                    print(value, terminator: " ")
                }
                print("")
            }
            print("---")
        }
    }

    
    fileprivate func multiArrayToArray(multiArray: MLMultiArray) -> [Double] {
        var array = [Double]()
        let count = multiArray.count
        for i in 0..<count {
            let value = multiArray[i].doubleValue
            array.append(value)
        }
        return array
    }

    
    
    fileprivate func sendErrorToIphone(message: String) {
        watchPhoneConnector.sendDataToiPhone(data: ["error": message, SharedConstants.entityType: "error message"])
        print(message)
        fatalError(message)
    }
    
    
    fileprivate func sendMlCallToIphone(input: MLMultiArray, output: [Double], modelType: String, timeArray: [(String, Double)]) {
        var data: [String: Any] = [:]
        //data["features"] = features
        data[SharedConstants.input] = multiArrayToArray(multiArray: input)
        data[SharedConstants.output] = output
        
        let timeDictionary = timeArray.map { ["firstElement": $0, "secondElement": $1] }
        data[SharedConstants.timeArray] = timeDictionary
        
        data[SharedConstants.sessionId] = appSessionService.currentSessionId.uuidString
        data[SharedConstants.entityType] = SharedConstants.mlCall
        data[SharedConstants.model] = modelType
        
        watchPhoneConnector.sendDataToiPhone(data: data)
    }
    
    /*
    fileprivate func sendRNNCallToIphone(input: MLMultiArray, output: RnnOutput, timeArray: [(String, Double)]) {
        print("Sending data")
        var data: [String: Any] = [:]
        //data["features"] = features
        data[SharedConstants.input] = multiArrayToOneDimensionalArray(multiArray: input)
        data[SharedConstants.output] = multiArrayToOneDimensionalArray(multiArray: output.Identity)
        
        let timeDictionary = timeArray.map { ["firstElement": $0, "secondElement": $1] }
        data[SharedConstants.timeArray] = timeDictionary
        
        data[SharedConstants.sessionId] = appSessionService.currentSessionId.uuidString
        data[SharedConstants.entityType] = SharedConstants.mlCall
        data[SharedConstants.model] = SharedConstants.rnn
        watchPhoneConnector.sendDataToiPhone(data: data)
        print("Data send")
    }*/
   

    
}
