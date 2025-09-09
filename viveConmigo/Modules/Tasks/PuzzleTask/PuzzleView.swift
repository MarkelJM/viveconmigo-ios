//
//  PuzzleView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import SwiftUI

struct PuzzleView: View {
    @StateObject var viewModel: PuzzleViewModel
    @EnvironmentObject var appState: AppState
    @State private var showInstructionsAlert = true
    @State private var showHelpSheet = false
    var body: some View {
        ZStack {
            Fondo() // Usamos el fondo común

            ScrollView {
                VStack {
                    if viewModel.isLoading {
                        Text("Cargando puzzles...")
                            .font(.title2)
                            .foregroundColor(.mateWhite)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    } else if let puzzle = viewModel.puzzles.first {
                        VStack(alignment: .leading) {
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
                                }

                                Spacer()

                                // Botón de ayuda con ícono de información
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

                                // Botón original
                                Button(action: {
                                    viewModel.checkPuzzle()
                                }) {
                                    Text("Comprobar Puzzle")
                                        .padding()
                                        .background(Color.mateBlueMedium)
                                        .foregroundColor(.mateWhite)
                                        .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.top, 50)


                            // Texto de la pregunta
                            Text(puzzle.question)
                                .font(.subheadline)
                                .foregroundColor(.mateGold)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 10)
                                .padding(.top, 30)
                            
                            GeometryReader { geometry in
                                ZStack {
                                    // Main Puzzle Image
                                    AsyncImage(url: URL(string: puzzle.questionImage)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                    }
                                    .padding()
                                    
                                    let scaleFactor = geometry.size.width / 500

                                    // Dropped Pieces
                                    ForEach(viewModel.droppedPieces.keys.sorted(), id: \.self) { key in
                                        if let imageUrl = puzzle.images[key], let position = viewModel.droppedPieces[key] {
                                            AsyncImage(url: URL(string: imageUrl)) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    //.frame(width: 50, height: 50)
                                                    .frame(width: 100 * scaleFactor, height: 100 * scaleFactor)
                                                    .position(x: position.x, y: position.y)
                                                    .gesture(
                                                        DragGesture()
                                                            .onChanged { value in
                                                                viewModel.updateDraggedPiecePosition(to: value.location, key: key)
                                                            }
                                                            .onEnded { _ in
                                                                viewModel.dropPiece()
                                                            }
                                                    )
                                            } placeholder: {
                                                ProgressView()
                                                    //.frame(width: 50, height: 50)
                                                    //.position(x: position.x, y: position.y)
                                                    .frame(width: 100 * scaleFactor, height: 100 * scaleFactor)
                                                    .position(x: position.x * scaleFactor, y: position.y * scaleFactor)
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(height: 500)
                            .padding()

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(puzzle.images.keys.sorted(), id: \.self) { key in
                                        if let imageUrl = puzzle.images[key] {
                                            AsyncImage(url: URL(string: imageUrl)) { image in
                                                image
                                                    .resizable()
                                                    .frame(width: 100, height: 100)
                                                    .padding()
                                                    .onTapGesture {
                                                        viewModel.selectPiece(key: key)
                                                    }
                                            } placeholder: {
                                                ProgressView()
                                                    .frame(width: 100, height: 100)
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                            }
                            .frame(height: 150)
                        }
                        .padding()
                        .background(Color.black.opacity(0.5)) // Fondo con opacidad para el VStack
                        .cornerRadius(20)
                        .sheet(isPresented: $viewModel.showResultSheet) {
                            ResulPuzzleSheetView(viewModel: viewModel)
                        }
                        .sheet(isPresented: $showHelpSheet) {
                            VStack(spacing: 20) {
                                Text("¿Cómo se juega?")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(.mateGold)
                                    .padding()

                                ScrollView {
                                    Text("Abajo verás unas imágenes, púlsalas una a una y verás que se muestran arriba dentro del puzzle. Una vez tengas las piezas identificadas, púlsalas y arrástralas suavemente a su lugar. IMPORTANTE: comienza a moverlas hacia un lateral, será más fácil moverlo.")
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

                        .alert(isPresented: $showInstructionsAlert) {
                            Alert(
                                title: Text("Instrucciones"),
                                message: Text("Primero debe seleccionar la imagen en la parte inferior y una vez que se muestre en el puzzle situarlo en su lugar."),
                                dismissButton: .default(Text("Entendido"))
                            )
                        }
                    } else {
                        Text("No hay puzzles disponibles")
                            .foregroundColor(.mateWhite)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchPuzzle()
        }
    }
}


struct ResulPuzzleSheetView: View {
    @ObservedObject var viewModel: PuzzleViewModel
    @EnvironmentObject var appState: AppState
    let soundManager = SoundManager.shared

    var body: some View {
        ZStack {
            Fondo() // Fondo común

            VStack {
                
                // Mostrar el mensaje de alerta
                Text(viewModel.alertMessage)
                    .font(.title)
                    .foregroundColor(.mateGold)
                    .padding()
                
                // ScrollView para mostrar el contenido original (informationDetail)
                ScrollView {
                    if let puzzle = viewModel.puzzles.first {  // Mostramos el primer puzzle
                        Text(puzzle.informationDetail)
                            .font(.title)
                            .padding()
                            .foregroundColor(.mateGold)
                    }
                }

                // Botón para mostrar la traducción en Euskera
                Button(action: {
                    viewModel.fetchTranslationForActivity(activityId: viewModel.activityId)  // Cargar la traducción en Euskera
                }) {
                    Label("Mostrar traducción en Inglés", systemImage: "globe")
                        .padding()
                        .background(Color.mateBlueMedium)
                        .foregroundColor(.mateWhite)
                        .cornerRadius(10)
                }

                // Botón para continuar
                Button(action: {
                    viewModel.showResultSheet = false
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
        .sheet(isPresented: $viewModel.showTranslationSheet) {
            // Sheet personalizado para mostrar la traducción
            TranslationSheetPuzzleView(viewModel: viewModel)
        }
        .onAppear {
            soundManager.playWinnerSound()
            //viewModel.fetchPuzzle()  // Cargar los datos del puzzle
        }
    }
}


struct TranslationSheetPuzzleView: View {
    @ObservedObject var viewModel: PuzzleViewModel
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
                viewModel.showTranslationSheet = false  // Cerrar el sheet
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
