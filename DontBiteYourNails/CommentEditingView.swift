//
//  CommentEditingView.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 13/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI
struct CommentEditingView: View {
    @Binding var comment: String
    @State private var tempComment: String
    @Environment(\.presentationMode) var presentationMode
    
    init(comment: Binding<String>) {
        _comment = comment
        _tempComment = State(initialValue: comment.wrappedValue)
    }
    
    var body: some View {
        VStack {
            if #available(iOS 14.0, *) {
                TextEditor(text: $tempComment)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            } else {
                // Fallback on earlier versions
            }
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Button("Save") {
                    comment = tempComment
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()
        }
    }
}
