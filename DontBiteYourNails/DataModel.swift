//
//  DataModel.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 29/07/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

class DataModel: ObservableObject {// I no longer know what this is and ifi it is needed. I hope not. I should try to delete it at some point
    @Published var confirmedCount: Int = 0
    @Published var ignoredCount: Int = 0
    @Published var deniedCount: Int = 0
}
