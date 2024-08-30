//
//  CustomActivityBlurView.swift
//  AImAware
//
//  Created by Suyog on 03/05/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

struct CustomActivityBlurView: UIViewRepresentable {
    @Binding var isLoading: Bool
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        // Customize your UIView here
        view.backgroundColor = UIColor.white
        view.isHidden = isLoading ? false : true
        view.layer.opacity = 1
        //view.intrinsicContentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update your UIView if needed
    }
}
