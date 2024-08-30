//
//  FAQElement.swift
//  DontBiteYourNails WatchKit Extension
//
//  Created by Sune Kristian Jakobsen on 24/03/2020.
//  Copyright © 2020 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct FAQElementView: View {
    let element: FAQElement
    var showAnswer = false
    
    var body: some View {
        
        VStack{
            HStack{
                Text(element.question).font(.headline)
                Spacer()
            }.padding()
            Text(element.answer).padding()
        }
    }
}

struct FAQElementView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            FAQElementView(element: faqData[0])
        }
    }
}
