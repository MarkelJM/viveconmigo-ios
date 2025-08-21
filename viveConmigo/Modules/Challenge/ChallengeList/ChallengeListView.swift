//
//  ChallengeListView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import SwiftUI

struct ChallengeListView: View {
    @StateObject var viewModel = ChallengeListViewModel()
    @EnvironmentObject var appState: AppState
    let soundManager = SoundManager.shared

    var body: some View {
        ZStack {
            Fondo() // Usamos el fondo común en lugar de una imagen

            VStack(spacing: 20) {
                Text("Retos")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.mateGold)
                    .padding(.top, 20)

                if viewModel.isUserLoaded {
                    List(viewModel.challenges) { challenge in
                        HStack {
                            AsyncImage(url: URL(string: challenge.image)) { image in
                                image
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                            } placeholder: {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                            }

                            Text(challenge.challengeTitle)
                                .font(.headline)
                                .foregroundColor(.mateWhite)
                                .padding(.leading, 16)

                            Spacer()

                            let completedTasks = viewModel.completedTasks(for: challenge.challengeName)

                            Text("\(completedTasks) / \(challenge.taskAmount)")
                                .font(.subheadline)
                                .foregroundColor(.mateWhite)
                                .padding(.trailing, 16)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.7))
                        .cornerRadius(20)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 5)
                        .onTapGesture {
                            soundManager.playButtonSound()
                            
                            if viewModel.isChallengeAlreadyBegan(challengeName: challenge.challengeName) {
                                viewModel.selectChallenge(challenge)
                                appState.currentView = .mapContainer
                            } else {
                                viewModel.selectChallenge(challenge)
                                appState.currentView = .challengePresentation(challengeName: challenge.challengeName)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(20)

                    Spacer()

                } else {
                    Text("Cargando datos...")
                        .font(.title)
                        .foregroundColor(.mateWhite)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.fetchChallenges()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Atención"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct ChallengeListView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeListView()
            .environmentObject(AppState())
    }
}

