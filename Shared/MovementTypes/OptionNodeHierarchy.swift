//
//  OptionNodeHierarchy.swift
//  DontBiteYourNails
//
//  Created by Sune on 03/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

class OptionNodeHierarchy : Identifiable {
    let value: String
    let fullName: String
    var children: [OptionNodeHierarchy]
    
    init(fullName: String, value: String, children: [OptionNodeHierarchy] = []) {
        self.fullName = fullName
        self.value = value
        self.children = children
    }
    
    var id: String {
        self.fullName
    }
    
    func addChild(node: OptionNodeHierarchy) {
        let existingChild = children.first { $0.value == node.value }
        if existingChild == nil {
            children.append(node)
        }
    }
    
    func addOtherOption() {
        if !children.isEmpty {
            let otherOption = OptionNodeHierarchy(fullName: self.fullName + "\\Other", value: "Other")
            self.addChild(node: otherOption)
        }
    }
}

class OptionNodeBuilder {
    let rootNode: OptionNodeHierarchy = OptionNodeHierarchy(fullName: "", value: "")
    
    func buildTree(from optionStrings: [String], addOtherOption: Bool) {
        for optionString in optionStrings {
            let components = optionString.split(separator: "\\").map(String.init)
            var currentNode = rootNode
            var fullNameCurrentNode = ""
            
            for component in components {
                fullNameCurrentNode = fullNameCurrentNode + "\\" + component
                if let existingChild = currentNode.children.first(where: { $0.value == component }) {
                    // Move to the existing child node
                    currentNode = existingChild
                } else {
                    let newNode = OptionNodeHierarchy(fullName: fullNameCurrentNode, value: component)
                    currentNode.addChild(node: newNode)
                    currentNode = newNode
                }
            }
        }
        
        if (addOtherOption) {
            addOtherOptionRecursively(node: rootNode)
        }
    }
    
    private func addOtherOptionRecursively(node: OptionNodeHierarchy) {
        node.addOtherOption()
        node.children.forEach { addOtherOptionRecursively(node: $0) }
    }
    
}
