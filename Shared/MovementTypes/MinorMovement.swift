//
//  MinorMovements.swift
//  DontBiteYourNails
//
//  Created by Sune on 03/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

class MinorMovementStructure {
    let rootNode: OptionNodeHierarchy
    
    init () {
        let builder = OptionNodeBuilder()
        builder.buildTree(from: options, addOtherOption: true)
        self.rootNode = builder.rootNode
    }
    
    
    let helptext = "Scratching means using nails, at least a bit. Can be up and down or back and forth. Can be 1 finger or all 4. Hand can be still or hand can be moving. Rubbing means not using nails "
    static let trainingList = ["Scratching hair/skin/beard",
                        "Rubbing skin/hair/beard",
                        "Rubbing nose",
                        "Picking nose",
                        "Picking ear",
                        "Blowing nose",
                        "Gentel thoughtful movements",
                        "Supporting the head",
                        "Searching, skinpicking",
                        "Skinpicking",
                        "Searching, hair pulling",
                        "Hairpulling",
                        "Eyebrow plucking",
                        "Nail biting",
                        "Eye rubbing",
                        "Adjusting glasses",
                        "Adjusting earphones"
    ]
    
    let options = [
        
        // gentel thoughful movements
        /*"Skin/scalp\\Scratching\\Side to side 4 fingers",
        "Skin/scalp\\Scratching\\Up and down\\Index finger",
        "Skin/scalp\\Scratching\\Up and down\\4 fingers\\In sync",
        "Skin/scalp\\Scratching\\Up and down\\4 fingers\\In wave",*/
        "Skin/scalp\\Scratching\\In wound",
        "Skin/scalp\\Scratching\\Skin",
        "Skin/scalp\\Scratching\\Hair/Scalp",
        /*"Skin/scalp\\Rubbing\\Rubbing with side of index finger",
        "Skin/scalp\\Rubbing\\Rubbing with finger tips",*/
        "Skin/scalp\\Rubbing",
        
        "Supporting head",

        "Nail biting\\Thumb\\Nail up",
        "Nail biting\\Thumb\\Nail down",
        "Nail biting\\Index finger",
        "Nail biting\\Middle finger",
        "Nail biting\\Ring finger",
        "Nail biting\\Little finger",

        "Nose\\Nose picking",
        /*"Nose\\Nose picking\\Watch side nostril",
        "Nose\\Nose picking\\Opposite side nostril",
        "Nose\\Nose picking\\Both nostrils simultaneously",*/
        "Nose\\Pinching/rubbing nose",
        /*"Nose\\Rubbing nose\\Rubbing index finger against nose",
        "Nose\\Rubbing nose\\Rubbing back of hand against nose",*/
        "Nose\\Smelling fingers/hand",
        /*"Nose\\Smelling\\Smelling fingers",
        "Nose\\Smelling\\Smelling back of hand",*/
        "Nose\\Blowing nose",

        "Eye/eyebrow\\Rubbing eye",
        "Eye/eyebrow\\Rubbing around eye",
        "Eye/eyebrow\\Pulling eyebrows/eyelids",
        "Eye/eyebrow\\Adjusting glasses",

        "Ear\\Picking inner ear\\Watch side",
        "Ear\\Picking inner ear\\Opposite side",
        /*"Ear\\Picking inner ear\\Little finger\\Watch side",
        "Ear\\Picking inner ear\\Little finger\\Opposite side",*/
        "Ear\\Outer ear\\Watch side",
        "Ear\\Outer ear\\Opposite side",
        "Ear\\Handling earphones or similar",

        "Hair\\Searching behavior",
        "Hair\\Hair pulling",
        "Hair\\Hair spinning",
    ]
    
}
