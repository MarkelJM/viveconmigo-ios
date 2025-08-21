//
//  CoinView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import SwiftUI
import ARKit
import RealityKit

struct CoinView: View {
    @ObservedObject var viewModel: CoinViewModel
    @EnvironmentObject var appState: AppState
    @State private var showHelpSheet = false
    
    var body: some View {
        ZStack {
            Fondo() // Usamos el fondo común
            
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    Text("Cargando datos...")
                        .font(.title2)
                        .foregroundColor(.mateWhite) // Color mateWhite
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else if let coin = viewModel.coins.first {
                    ARViewContainer(prizeImageName: coin.prize, viewModel: viewModel)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Text("No hay datos disponibles")
                        .foregroundColor(.mateWhite) // Color mateWhite
                }
            }
            
            VStack {
                HStack {
                    Button(action: {
                        appState.currentView = .mapContainer
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .padding()
                            .background(Color.mateGold)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(.top, 100)
                    }

                    Spacer()

                    // Botón de ayuda accesible
                    Button(action: {
                        showHelpSheet = true
                    }) {
                        Image(systemName: "info.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.mateGold)
                            .padding(8)
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                .padding([.top, .leading, .trailing], 20)

                
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.showResultModal) {
            ResultCoinView(viewModel: viewModel)
                .environmentObject(appState)
        }
        .sheet(isPresented: $showHelpSheet) {
            VStack(spacing: 20) {
                Text("¿Cómo se juega?")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.mateGold)
                    .padding()

                ScrollView {
                    Text("Busca el objeto, muévete por la zona hasta localizarlo. Pulsa encima tres veces hasta que te salga el mensaje.")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.mateWhite)
                }

                Button("Cerrar") {
                    showHelpSheet = false
                }
                .padding()
                .background(Color.mateBlueMedium)
                .foregroundColor(.mateWhite)
                .cornerRadius(10)
            }
            .padding()
            .background(Color.black)
        }

    }
}


struct ResultCoinView: View {
    @ObservedObject var viewModel: CoinViewModel
    @EnvironmentObject var appState: AppState
    let soundManager = SoundManager.shared
    
    @State private var showTranslationSheet = false

    var body: some View {
        ZStack {
            Fondo() // Fondo común

            VStack {
                
                // Mostrar el mensaje de alerta
                Text(viewModel.alertMessage)
                    .font(.title)
                    .foregroundColor(.mateGold)
                    .padding()
                // ScrollView para mostrar el contenido original (description)
                ScrollView {
                    if let coin = viewModel.coins.first {  // Mostramos la descripción del primer coin
                        Text(coin.description)
                            .font(.title)
                            .padding()
                            .foregroundColor(.mateGold)
                    }
                }

                // Botón para mostrar la traducción
                Button(action: {
                    viewModel.fetchTranslationForActivity(activityId: viewModel.activityId)  // Buscar traducción en Euskera
                    showTranslationSheet = true
                }) {
                    Label("Mostrar traducción en Euskera", systemImage: "globe")
                        .padding()
                        .background(Color.mateBlueMedium)
                        .foregroundColor(.mateWhite)
                        .cornerRadius(10)
                }

                // Botón para continuar
                Button(action: {
                    viewModel.showResultModal = false
                    appState.currentView = .mapContainer
                }) {
                    Text("Continuar")
                        .padding()
                        .background(Color.mateBlueMedium)
                        .foregroundColor(.mateWhite)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
            .padding()
        }
        .sheet(isPresented: $showTranslationSheet) {
            TranslationSheetCoinView(viewModel: viewModel)  // Sheet personalizado para la traducción
        }
        .onAppear {
            soundManager.playWinnerSound()
            viewModel.fetchAvailableLanguages() // Obtener los idiomas disponibles
        }
    }
}


struct TranslationSheetCoinView: View {
    @ObservedObject var viewModel: CoinViewModel
    @EnvironmentObject var appState: AppState


    var body: some View {
        VStack {
            // Contenido dentro de un ScrollView para manejar traducciones largas
            ScrollView {
                VStack(alignment: .leading) {
                    // Mostrar la traducción si existe
                    if let translation = viewModel.translation {
                        Text(translation.text)
                            .font(.title)
                            .padding()
                            .foregroundColor(.mateGold)

                        if let url = translation.url, let urlLink = URL(string: url) {
                            Link("Más información", destination: urlLink)
                                .foregroundColor(.blue)
                                .padding()
                        }
                    } else {
                        Text("No hay traducción disponible")
                            .font(.title)
                            .padding()
                            .foregroundColor(.mateGold)
                    }
                }
            }
            .padding()

            // Botón para cerrar el sheet
            Button(action: {
                viewModel.showResultModal = false // Cerrar el sheet
                appState.currentView = .mapContainer

            }) {
                Text("Cerrar")
                    .padding()
                    .background(Color.mateBlueMedium)
                    .foregroundColor(.mateWhite)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
