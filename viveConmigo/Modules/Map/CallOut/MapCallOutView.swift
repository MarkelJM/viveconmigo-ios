//
//  MapCallOutView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import SwiftUI

struct MapCallOutView: View {
    var spot: Spot?
    var reward: ChallengeReward?
    var challenge: String?
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel: BaseMapViewModel // Cambio aquí
    @State private var showCompletedAlert = false
    let soundManager = SoundManager.shared

    var body: some View {
        VStack(spacing: 20) {
            if let reward = reward, let challenge = challenge {
                Text(reward.challengeTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.mateBlueMedium)

                Text(reward.abstract)
                    .font(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Image(systemName: "star.circle.fill")
                    .resizable()
                    .foregroundColor(.yellow)
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)

                Button(action: {
                    viewModel.saveSpotID(reward.id)
                    appState.currentView = .challengeReward(challengeName: reward.challenge)
                }) {
                    Text("Obtener Recompensa")
                        .font(.headline)
                        .foregroundColor(.mateWhite)
                        .padding()
                        .background(Color.mateGold)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            } else if let spot = spot {
                Text(spot.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.mateBlueMedium)
                
                Text(spot.abstract)
                    .font(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                AsyncImage(url: URL(string: spot.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                } placeholder: {
                    ProgressView()
                }
                .padding(.horizontal)

                Button(action: {
                    if viewModel.isTaskCompleted(taskID: spot.activityID, activityType: spot.activityType, challenge: viewModel.selectedChallenge) {
                        showCompletedAlert = true
                    } else {
                        soundManager.playButtonSound()
                        viewModel.saveSpotID(spot.id)
                        navigateToActivity(for: spot)
                    }
                }) {
                    Text("Participar")
                        .font(.headline)
                        .foregroundColor(.mateWhite)
                        .padding()
                        .background(Color.mateBlueMedium)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .alert(isPresented: $showCompletedAlert) {
                    Alert(
                        title: Text("Aviso"),
                        message: Text("Tarea ya completada."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.mateWhite.opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 10)
    }

    private func navigateToActivity(for spot: Spot) {
        print("Navigating to activity: \(spot.activityType) with activityID: \(spot.activityID)")

        switch spot.activityType {
        case "puzzles":
            appState.currentView = .puzzle(id: spot.activityID)
        case "coins":
            appState.currentView = .coin(id: spot.activityID)
        case "dates":
            appState.currentView = .dates(id: spot.activityID)
        case "fillGap":
            appState.currentView = .fillGap(id: spot.activityID)
        case "questionAnswers":
            appState.currentView = .questionAnswer(id: spot.activityID)
        case "takePhotos":
            appState.currentView = .takePhoto(id: spot.activityID)
        default:
            print("Tipo de actividad no soportado: \(spot.activityType)")
        }
    }
}
