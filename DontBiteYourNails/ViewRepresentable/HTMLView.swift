//
//  HTMLView.swift
//  AImAware
//
//  Created by Maulik Bhuptani on 28/02/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI
import WebKit

struct HTMLView: UIViewRepresentable {

    let fileName: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "html") else { return }
        webView.load(URLRequest(url: url))
    }
}
