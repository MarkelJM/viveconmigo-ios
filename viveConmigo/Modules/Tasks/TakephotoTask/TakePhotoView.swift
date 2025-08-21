//
//  TakePhotoView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import SwiftUI
import AVFoundation

struct TakePhotoView: View {
    @StateObject var viewModel: TakePhotoViewModel
    @EnvironmentObject var appState: AppState

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
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)

                    if viewModel.isLoading {
                        Text("Cargando tarea de foto...")
                            .font(.title2)
                            .foregroundColor(.mateWhite) // Usamos mateWhite
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    } else if let takePhoto = viewModel.takePhoto {
                        VStack(spacing: 20) {
                            Text(takePhoto.question)
                                .font(.title2)
                                .foregroundColor(.mateGold) // Usamos mateGold
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            Button(action: {
                                checkCameraPermission()
                            }) {
                                Text("Tomar Foto")
                                    .padding()
                                    .background(Color.mateBlueMedium) // Usamos mateBlueMedium
                                    .foregroundColor(.mateWhite)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
                .padding()
                .sheet(isPresented: $viewModel.showResultModal) {
                    ResultTakePhotoView(viewModel: viewModel)
                }
            }
            .onAppear {
                viewModel.fetchTakePhoto()
            }
        }
    }

    func checkCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                openCamera()
            } else {
                print("Permiso denegado para usar la cámara")
            }
        }
    }

    func openCamera() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraView = CameraView(viewModel: viewModel)
                let controller = UIApplication.shared.windows.first?.rootViewController
                controller?.present(UIHostingController(rootView: cameraView), animated: true, completion: nil)
            } else {
                print("La cámara no está disponible en este dispositivo")
            }
        }
    }
}






struct ResultTakePhotoView: View {
    @ObservedObject var viewModel: TakePhotoViewModel
    @EnvironmentObject var appState: AppState
    let soundManager = SoundManager.shared
    @State private var showTranslationSheet = false // Estado para controlar la apertura del sheet

    var body: some View {
        ZStack {
            Fondo() // Usamos el fondo común

            VStack {
                
                // Mostrar el mensaje de alerta
                Text(viewModel.alertMessage)
                    .font(.title)
                    .foregroundColor(.mateGold)
                    .padding()
                
                ScrollView {
                    // Mostrar el contenido en Español (informationDetail)
                    if let takePhoto = viewModel.takePhoto {
                        Text(takePhoto.informationDetail)
                            .font(.title)
                            .foregroundColor(.mateGold)
                            .padding()
                    }
                }

                // Botón para mostrar la traducción en Euskera
                Button(action: {
                    viewModel.fetchTranslationForActivity(activityId: viewModel.activityId) // Cargar la traducción
                    showTranslationSheet = true // Mostrar el sheet para traducción
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
        // Mostrar el sheet para la traducción
        .sheet(isPresented: $showTranslationSheet) {
            TranslationSheetTakePhotoView(viewModel: viewModel) // Sheet personalizado para la traducción
        }
        .onAppear {
            soundManager.playWinnerSound() // Reproducir sonido cuando aparezca el resultado
        }
    }
}



struct TranslationSheetTakePhotoView: View {
    @ObservedObject var viewModel: TakePhotoViewModel
    @EnvironmentObject var appState: AppState


    var body: some View {
        VStack {
            // Menú para seleccionar idioma
            HStack {
                Text("Mostrar traducción:")
                    .foregroundColor(.mateGold)
            }
            .padding()

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
                viewModel.showResultModal = false
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
