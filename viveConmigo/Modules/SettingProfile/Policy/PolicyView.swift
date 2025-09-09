//
//  PolicyView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import SwiftUI

struct PolicyView: View {
    
    private let url = URL(string: "https://euskadirago.wordpress.com/2024/10/02/terminoscondiciones/")!
    
    var body: some View {
        ZStack {
            Fondo() // Usamos el fondo común
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("Términos y Condiciones")
                        .font(.largeTitle)
                        .foregroundColor(.mateGold) // Usamos mateGold
                        .padding()
                    
                    WebView(url: url)
                        .frame(height: 400)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
                .padding()
            }
        }
    }
}

#Preview {
    PolicyView()
}


