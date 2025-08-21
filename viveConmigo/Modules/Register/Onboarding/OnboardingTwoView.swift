//
//  OnboardingTwoView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//

import SwiftUI

struct OnboardingTwoView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            // Fondo de pantalla
            Fondo()

            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Button(action: {
                                appState.currentView = .onboardingOne
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
                        
                        Text("Continuación de la historia")
                            .font(.title)
                            .foregroundColor(.mateGold)
                            .padding(.top, 40)
                        
                        Text("""
                            Elige el reto que más te guste. Puedes elegir rutas por los diferentes territorios históricos, ciudades, gastronomía o incluso sobre el Euskera.  Tras finalizar cada reto conseguirás una recompensa.
                            """)
                            .font(.body)
                            .foregroundColor(.mateWhite)
                    }
                    .padding()
                }
                
                Spacer()
                
                Button(action: {
                    appState.currentView = .registerEmail
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
            .background(Color.black.opacity(0.6))
            .cornerRadius(20)
            .padding()
        }
    }
}
