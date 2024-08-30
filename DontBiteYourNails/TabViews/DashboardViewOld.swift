//
//  Dashboard.swift
//  AImAware
//
//  Created by Sune on 07/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct DashboardViewOld: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Greeting and Profile Picture
                    HStack {
                        Text("Hello Sune")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Image("profile") // Replace with actual image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    .padding(.horizontal)
                    
                    // Cards
                    VStack(spacing: 20) {
                        // This is an example of a single card, replicate for others
                        cardView(title: "21", subtitle: "Congratulations! You've been 21 days without biting your nails!")
                        
                        
                        
                        HStack(spacing: 20) {
                            cardView(title: "1", subtitle: "Days you have used the app")
                            cardView(title: "10", subtitle: "Minutes you have used the app")
                        }
                        
                    
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    // Function to create a card view
    func cardView(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            
            Text(subtitle)
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
        .shadow(radius: 5)
        .frame(maxWidth: .infinity)
}

