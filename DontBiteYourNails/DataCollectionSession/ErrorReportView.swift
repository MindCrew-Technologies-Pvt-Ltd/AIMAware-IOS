//
//  ErrorReportView.swift
//  AImAware
//
//  Created by Sune on 09/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct ErrorReportView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var errorDescription = ""
    var completionHandler: (String) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Describe the error you made, and we will try to adapt when cleaning the data...", text: $errorDescription)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Submit") {
                    completionHandler(errorDescription)
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
            }
            .navigationBarTitle("Report Error", displayMode: .inline)
        }
    }
}
