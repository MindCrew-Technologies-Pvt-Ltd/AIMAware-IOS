//
//  ExportableMlCall.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 27/09/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

struct ExportableMlCall : Encodable {
    
    var input: String
    //var features: [String: Double]
    var output: String
    //var outputString: String
    //var outputProbability: Double
    var timeDone: Date
    var beforeTime: Date
    var featuresCalculatedTime: Date
    var modelType : String?

    
    init(from mlCall : MlCall) {
        /*if let jsonData = mlCall.features?.data(using: .utf8),
           let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Double] {
            self.features = jsonDict
        } else {
            self.features = [:] // Empty dictionary if JSON conversion fails
        }*/
        
        self.input = mlCall.features ?? ""
        //self.output = mlCall.output
        self.output = mlCall.outputString ?? ""
        //self.outputProbability = mlCall.outputProbability
        self.timeDone = mlCall.timeDone ?? Date.init(timeIntervalSince1970: 0)
        self.beforeTime = mlCall.beforeTime ?? Date.init(timeIntervalSince1970: 0)
        self.featuresCalculatedTime = mlCall.featuresCalculatedTime ?? Date.init(timeIntervalSince1970: 0)
        self.modelType = mlCall.modelType
        print("MLcall inited")
    }
   /*
    // Custom Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode simple fields
        try container.encode(output, forKey: .output)
        try container.encode(outputProbability, forKey: .outputProbability)
        try container.encode(timeDone, forKey: .timeDone)
        try container.encode(beforeTime, forKey: .beforeTime)
        try container.encode(featuresCalculatedTime, forKey: .featuresCalculatedTime)
        
        try container.encode(features, forKey: .features)
        // Handle nested JSON manually
        //let featuresData = try JSONSerialization.data(withJSONObject: features, options: [])
        //try container.encode(featuresData, forKey: .features)
    }
    
    // Define the keys used for encoding
    enum CodingKeys: String, CodingKey {
        case features, output, outputProbability, timeDone, beforeTime, featuresCalculatedTime
    }*/
}
