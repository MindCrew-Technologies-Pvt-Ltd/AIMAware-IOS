//
//  TutorialLayoutView.swift
//  AImAware
//
//  Created by Suyog on 18/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct TutorialLayoutView: View {
    let page: Page

    var body: some View {
        VStack {
            ZStack{
                Image(page.outerImageName)
                    
                Image(page.innerImageName)
                    
            } .padding(.bottom, 60)
            

            Text(page.title)
                .multilineTextAlignment(.center)
                .font(.setCustom(fontStyle: .title3, fontWeight: .regular))
                                       .padding(.horizontal, 10.0)
                                       .padding()
        }
    }
}
