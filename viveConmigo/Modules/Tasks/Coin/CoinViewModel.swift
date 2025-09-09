//
//  CoinViewModel.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import SwiftUI
import Combine

class CoinViewModel: BaseViewModel {
    @Published var coins: [Coin] = []
    @Published var isLoading: Bool = true
    @Published var showResultModal: Bool = false
    @Published var resultMessage: String = ""



    private let dataManager = CoinDataManager()
    var activityId: String
    private var appState: AppState

    init(activityId: String, appState: AppState) {
        self.activityId = activityId
        self.appState = appState
        super.init()
        fetchUserProfile()
        fetchCoinById(activityId)
        fetchAvailableLanguages()
    }
    

    

    
    func fetchCoinById(_ id: String) {
        isLoading = true
        dataManager.fetchCoinById(id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { coin in
                
                
                self.coins = [coin]
                self.isLoading = false
                 
            }
            .store(in: &cancellables)
    }
    
    func completeTask(coin: Coin) {
        guard let user = user else { return }
        
        if user.challenges[coin.challenge]?.contains(coin.id) == true {
            print("Task ID already exists, not adding again.")
            return
        }

        updateTaskForUser(taskID: coin.id, challenge: coin.challenge)
        updateSpotForUser()

        self.resultMessage = coin.correctAnswerMessage
        self.showResultModal = true
    }

    private func updateTaskForUser(taskID: String, challenge: String) {
        firestoreManager.updateUserTaskIDs(taskID: taskID, challenge: challenge)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertMessage = "Error actualizando la tarea: \(error.localizedDescription)"
                    self.showAlert = true
                case .finished:
                    break
                }
            } receiveValue: { [weak self] _ in
                print("User task updated in Firestore")
                //self?.appState.currentView = .mapContainer
            }
            .store(in: &cancellables)
    }

    private func updateSpotForUser() {
        if let spotID = userDefaultsManager.getSpotID() {
            firestoreManager.updateUserSpotIDs(spotID: spotID)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        self.alertMessage = "Error actualizando el spot: \(error.localizedDescription)"
                        self.showAlert = true
                    case .finished:
                        break
                    }
                } receiveValue: { _ in
                    print("User spot updated in Firestore")
                }
                .store(in: &cancellables)

            userDefaultsManager.clearSpotID()
        } else {
            print("No spotID found in UserDefaults")
        }
    }
}
