//
//  FillGapViewModel.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import SwiftUI
import Combine

class FillGapViewModel: BaseViewModel {
    @Published var fillGap: FillGap?
    @Published var isLoading: Bool = true
    @Published var userAnswers: [String] = []
    @Published var showResultAlert: Bool = false
    
    private let dataManager = FillGapDataManager()
    var activityId: String
    private weak var appState: AppState? // Referencia débil a AppState

    init(activityId: String, appState: AppState) {
        self.activityId = activityId
        self.appState = appState
        super.init()
        fetchUserProfile()
        fetchFillGap()
        fetchAvailableLanguages()
    }
    
    func fetchFillGap() {
        isLoading = true
        dataManager.fetchFillGapById(activityId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { fillGap in
                self.fillGap = fillGap
                self.userAnswers = Array(repeating: "", count: fillGap.correctPositions.count)
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func submitAnswers() {
        guard let fillGap = fillGap else { return }
        
        // Normalizar respuestas a minúsculas y eliminar espacios en blanco al inicio y al final
        let normalizedUserAnswers = userAnswers.map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
        let normalizedCorrectAnswers = fillGap.correctPositions.map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
        
        if normalizedUserAnswers == normalizedCorrectAnswers {
            alertMessage = fillGap.correctAnswerMessage
            updateUserTask(fillGap: fillGap)
            updateSpotForUser()
        } else {
            alertMessage = fillGap.incorrectAnswerMessage
        }
        
        showResultAlert = true
    }
    
    private func updateUserTask(fillGap: FillGap) {
        updateTaskForUser(taskID: fillGap.id, challenge: fillGap.challenge)
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
                //self?.appState?.currentView = .mapContainer
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
