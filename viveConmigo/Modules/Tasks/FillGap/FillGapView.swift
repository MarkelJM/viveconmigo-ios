//
//  FillGapView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import SwiftUI

struct FillGapView: View {
    @StateObject var viewModel: FillGapViewModel
    @EnvironmentObject var appState: AppState
    @State private var showAlert = false
    @State private var missingFieldsMessage = ""

    var body: some View {
        ScrollView {
            ZStack {
                Fondo() // Usamos el fondo común
                
                VStack(spacing: 10) {
                    
                    HStack {
                        Button(action: {
                            appState.currentView = .mapContainer
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                                .padding()
                                .background(Color.mateGold) // Usamos mateGold
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                        Spacer()
                        Button(action: {
                            if viewModel.userAnswers.contains(where: { $0.isEmpty }) {
                                alertUserToFillAllFields()
                            } else {
                                viewModel.submitAnswers()
                            }
                        }) {
                            Text("Comprobar")
                                .padding()
                                .background(Color.mateBlueMedium) // Usamos mateBlueMedium
                                .foregroundColor(.mateWhite)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)

                    if viewModel.isLoading {
                        Text("Cargando tarea...")
                            .font(.title2)
                            .foregroundColor(.mateWhite) // Usamos mateWhite
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    } else if let fillGap = viewModel.fillGap {
                        VStack(spacing: 20) {
                            Text(fillGap.question)
                                .font(.title2)
                                .foregroundColor(.mateGold) // Usamos mateGold
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            AsyncImage(url: URL(string: fillGap.images)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 300)
                            } placeholder: {
                                ProgressView()
                                    .frame(maxWidth: 300)
                            }

                            // Etiquetas para los campos de texto
                            ForEach(0..<fillGap.correctPositions.count, id: \.self) { index in
                                HStack {
                                    Text("\(Character(UnicodeScalar(65 + index)!)).") // Muestra "A.", "B.", "C.", etc.
                                        .font(.headline)
                                        .foregroundColor(.mateGold) // Usamos mateGold

                                    TextField("Escribe aquí", text: $viewModel.userAnswers[index])
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                        .background(Color.mateWhite.opacity(0.8)) // Usamos mateWhite
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
                .padding()
                .sheet(isPresented: $viewModel.showResultAlert) {
                    ResultFillGapView(viewModel: viewModel)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Campos Incompletos"),
                        message: Text(missingFieldsMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .onAppear {
                viewModel.fetchFillGap()
            }
        }
    }
    
    private func alertUserToFillAllFields() {
        let missingIndices = viewModel.userAnswers.enumerated()
            .filter { $0.element.isEmpty }
            .map { "Campo \($0.offset + 1)" }

        missingFieldsMessage = "Debes rellenar los siguientes campos:\n" + missingIndices.joined(separator: ", ")
        showAlert = true
    }
}


struct ResultFillGapView: View {
    @ObservedObject var viewModel: FillGapViewModel
    @EnvironmentObject var appState: AppState
    let soundManager = SoundManager.shared
    
    var body: some View {
        ZStack {
            Fondo() // Usamos el fondo común

            VStack {
                Text(viewModel.alertMessage)
                    .font(.title)
                    .foregroundColor(.mateGold) // Usamos mateGold
                    .padding()

                Button(action: {
                    viewModel.showResultAlert = false
                    appState.currentView = .mapContainer
                }) {
                    Text("Continuar")
                        .padding()
                        .background(Color.mateBlueMedium) // Usamos mateBlueMedium en lugar de mateRed
                        .foregroundColor(.mateWhite) // Usamos mateWhite
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
            .padding()
        }
        .onAppear {
            soundManager.playWinnerSound() // Reproducir sonido cuando aparezca el resultado
        }
    }
}
