//
//  ActivityViewController.swift
//  AImAware
//
//  Created by Sune on 21/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//


import SwiftUI
import Combine

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}
