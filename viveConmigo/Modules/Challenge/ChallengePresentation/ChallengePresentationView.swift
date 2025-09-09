//
//  ChallengePresentationView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import SwiftUI
import Combine

struct ChallengePresentationView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: ChallengePresentationViewModel
    let soundManager = SoundManager.shared

    var body: some View {
        ZStack {
            Fondo() // Usamos el fondo común

            VStack(spacing: 20) {
                Spacer()
                
                Button(action: {
                       appState.currentView = .challengeList
                   }) {
                       HStack {
                           Image(systemName: "arrow.left")
                       }
                       .font(.headline)
                       .padding()
                       .background(Color.mateGold) // Usamos mateGold
                       .foregroundColor(.black)
                       .cornerRadius(10)
                   }
                   .padding(.leading)
                
                if let challenge = viewModel.challenge {
                    Image(viewModel.userAvatar)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .padding(.top, 40)

                    VStack(alignment: .leading) {
                        Text(challenge.challengeMessage)
                            .font(.title2)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 40)
                    
                    Spacer()
                
                    Button(action: {
                        soundManager.playButtonSound()

                        viewModel.beginChallenge()
                            .sink(receiveCompletion: { completion in
                                switch completion {
                                case .finished:
                                    appState.currentView = .mapContainer
                                case .failure(let error):
                                    viewModel.alertMessage = "Error updating challenge: \(error.localizedDescription)"
                                    viewModel.showAlert = true
                                }
                            }, receiveValue: { })
                            .store(in: &viewModel.cancellables)
                    }) {
                        Text("Comenzar")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.mateBlueMedium) // Usamos mateBlueMedium en lugar de mateRed
                            .foregroundColor(.mateWhite) // Usamos mateWhite
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                    }
                    Spacer()
                    
                } else {
                    Text("Cargando...")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
            .padding()
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Mensaje"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear {
            viewModel.fetchUserProfile()
        }
    }
}
