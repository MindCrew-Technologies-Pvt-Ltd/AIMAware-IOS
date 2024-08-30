//
//  CircularBuffer.swift
//  DontBiteYourNails WatchKit Extension
//
//  Created by Sune Kristian Jakobsen on 26/09/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

// Used to store last size elements and automatically overwrite oldest values if we have more than this number
struct CircularBuffer {
    private var buffer: [Double?]
    private var start = 0
    private var end = 0
    
    init(size: Int) {
        buffer = [Double?](repeating: nil, count: size)
    }
    
    mutating func addElement(_ element: Double) {
        buffer[end] = element
        end = (end + 1) % buffer.count
        if end == start {
            start = (start + 1) % buffer.count
        }
    }
    
    func getPaddedElements() -> [Double] {
        pad(array: getElements(), toSize: buffer.count)
    }
    
    func getElements() -> [Double] {
        var elements = [Double]()
        var index = start
        while true {
            if let element = buffer[index] {
                elements.append(element)
            }
            index = (index + 1) % buffer.count
            if index == end {
                break
            }
        }
        return elements
    }
    
    func pad(array: [Double], toSize size: Int) -> [Double] {
        var paddedArray = array
        while paddedArray.count < size {
            paddedArray.insert(0, at: 0)  // Prepend zeros
        }
        return paddedArray
    }
    
    func getAverage() -> Double {
        let filteredBuffer = buffer.compactMap { $0 }
        
        if !filteredBuffer.isEmpty {
            let sum = filteredBuffer.reduce(0, +)
            return sum / Double(filteredBuffer.count)
        } else {
            return 0
        }
    }
    
    mutating func clear(){
        self.buffer = [Double?](repeating: nil, count: buffer.count)
        self.start = 0
        self.end = 0
    }
}
