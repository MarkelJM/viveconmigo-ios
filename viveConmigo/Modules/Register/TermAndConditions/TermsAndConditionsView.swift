//
//  TermsAndConditionsView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import SwiftUI
import Combine

struct TermsAndConditionsView: View {
    @EnvironmentObject var appState: AppState
    @Binding var agreeToTerms: Bool
    private let url = URL(string: "https://euskadirago.wordpress.com/2024/10/02/terminoscondiciones/")!
    
    var body: some View {
        ZStack {
            Fondo()

            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: {
                            appState.currentView = .registerEmail
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                                .padding()
                                .background(Color.mateGold) // Usamos mateGold
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                        Spacer()
                    }
                    .padding([.top, .leading], 20)
                    
                    Spacer()
                    
                    Text("Términos y Condiciones")
                        .font(.largeTitle)
                        .foregroundColor(.mateGold) // Usamos mateGold
                        .padding()
                    
                    // Aquí va la WebView que carga el enlace
                    WebView(url: url)
                        .frame(height: 400)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: {
                        agreeToTerms = true
                        appState.currentView = .registerEmail
                    }) {
                        Text("Aceptar")
                            .padding()
                            .background(Color.mateBlueMedium) // Usamos mateBlueMedium en lugar de mateRed
                            .foregroundColor(.mateWhite) // Usamos mateWhite
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 50)
                }
                .background(Color.black.opacity(0.5)) // Fondo con opacidad
                .cornerRadius(20)
                .padding()
            }
        }
    }
}

#Preview {
    TermsAndConditionsView(agreeToTerms: .constant(false))
        .environmentObject(AppState())
}

