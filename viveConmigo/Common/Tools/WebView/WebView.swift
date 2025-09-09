//
//  WebView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import SwiftUI
import WebKit
import Combine

// WebView wrapper para cargar la página web dentro de SwiftUI
struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
