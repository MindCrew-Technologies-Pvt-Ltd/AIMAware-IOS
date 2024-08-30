//
//  RootView.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 29/07/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//


import SwiftUI

struct RootView: View {
    var body: some View {
        ContentView()
            .environmentObject(DataModel())
    }
}
