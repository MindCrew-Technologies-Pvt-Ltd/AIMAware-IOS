//
//  CustomBottomNavigationView.swift
//  AImAware
//
//  Created by Suyog on 19/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct CustomBottomNavigationView: View {
    var primaryText: String
    var secondaryText: String
    var onClicked: (() -> ())
    var body: some View {
        HStack{
            
            Text(primaryText)
                .font(.setCustom(fontStyle: .headline, fontWeight: .medium))
            Button {
                onClicked()
            } label: {
                Text(secondaryText)
                    
                    .foregroundColor(Color(red: 62/255, green: 156/255, blue: 226/255))
                    .overlay {
                        BottomSeparatorView(backgroundColor: Color(red: 62/255, green: 156/255, blue: 226/255))
                    }
                    .font(.setCustom(fontStyle: .headline, fontWeight: .bold))
                    
            }
           
        }.background(Color(.white))
    }
}

#Preview {
    
    ZStack{
        Rectangle().ignoresSafeArea()
        CustomBottomNavigationView(primaryText: "Don’t have an account yet?", secondaryText: "Sign up", onClicked: {})
    }
}
