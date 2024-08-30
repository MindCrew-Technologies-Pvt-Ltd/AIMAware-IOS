//
//  Data.swift
//  Dont2
//
//  Created by Sune Kristian Jakobsen on 11/03/2020.
//  Copyright © 2020 Sune Kristian Jakobsen. All rights reserved.
//


import UIKit
import SwiftUI
import CoreLocation

let faqData: [FAQElement] = load("FAQ.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
