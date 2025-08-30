//
//  OnboardingOneView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import SwiftUI

struct OnboardingOneView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Fondo()

            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Button(action: {
                                appState.currentView = .login
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.mateGold)
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .padding(.top, 50)
                            }
                            Spacer()
                        }
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Bienvenido a nuestra historia")
                                .font(.title)
                                .foregroundColor(.mateGold)
                                .padding(.top, 40)
                            
                            Text("""
                                Seguro que eres Madrileño? Yo, vivo en estos lugares desde hace mucho tiempo…y desde el siglo XIII soy incluso el símbolo de la ciudad! Pero esta ciudad ha cambiado tanto que siempre encuentro nuevos tesoros que enseñar an mis amigos. Te animas a hacer una ruta gamificada conmigo? Anímate, por el camino encontraremos ricas recompensas (como mis queridos madroños) y premios! 
                                """)
                                .font(.body)
                                .foregroundColor(.mateWhite)
                        }
                        .padding()
                    }
                }
                
                Spacer()
                
                Button(action: {
                    appState.currentView = .onboardingTwo
                }) {
                    Text("Continuar")
                        .padding()
                        .background(Color.mateBlueMedium)
                        .foregroundColor(.mateWhite)
                        .cornerRadius(10)
                        .padding(.bottom, 40)
                }
                Spacer()
            }
            .padding()
            .background(Color.black.opacity(0.6)) // Fondo con opacidad
            .cornerRadius(20)
            .padding()
        }
    }
}
