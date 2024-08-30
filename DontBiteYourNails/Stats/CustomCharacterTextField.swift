//
//  CustomCharacterTextField.swift
//  AImAware
//
//  Created by Suyog on 24/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct CustomCharacterTextFieldView: UIViewRepresentable {
    @Binding var text: String
    @Binding var keyBoardType: UIKeyboardType
    @Binding var placeholderText : String
    var textField = UITextField()
    
    func makeUIView(context: Context) -> UITextField {
        print(text)
        textField.delegate = context.coordinator
        textField.text = text
        textField.placeholder = placeholderText
        textField.keyboardType = keyBoardType
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonAction(button:)))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textField.inputAccessoryView = doneToolbar
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    func addDoneButtonOnKeyboard(){
        
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string: String) -> Bool {
            // Get the current text in the textField
            guard let currentText = textField.text,
                  let textRange = Range(range, in: currentText) else {
                return true
            }
            
            // Construct the new text after replacement
            let newText = currentText.replacingCharacters(in: textRange, with: string)
            
            // Disallow input if the total character count exceeds 13 or contains a space
            if !string.isEmpty {
                if newText.count > 3{
                    return false
                }
                text = newText
                
            }else{
                text = newText
            }

            return true
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool{
            textField.resignFirstResponder()
            return true
        }
        
    }
    
}
extension  UITextField {
    @objc func doneButtonAction(button:UIBarButtonItem) -> Void {
        self.resignFirstResponder()
    }
}
