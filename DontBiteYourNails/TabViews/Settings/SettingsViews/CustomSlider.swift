//
//  CustomSlider.swift
//  AImAware
//
//  Created by Suyog on 06/05/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct SliderView: UIViewRepresentable {
    @Binding var value: Double
    var thumbColor: UIColor

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.thumbTintColor = thumbColor
        slider.value = Float(value)
        slider.minimumValue = 0
        slider.maximumValue = 5
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged), for: .valueChanged)
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.thumbTintColor = thumbColor
        uiView.value = Float(value)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(value: $value)
    }

    class Coordinator: NSObject {
        @Binding var value: Double

        init(value: Binding<Double>) {
            _value = value
        }

        @objc func valueChanged(_ sender: UISlider) {
            value = Double(sender.value)
        }
    }
}
