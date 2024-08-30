//
//  FAQElement.swift
//  Dont2
//
//  Created by Sune Kristian Jakobsen on 11/03/2020.
//  Copyright © 2020 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct FAQElement: Hashable, Codable, Identifiable {
    var id: Int
    var question: String
    var answer: String
}
