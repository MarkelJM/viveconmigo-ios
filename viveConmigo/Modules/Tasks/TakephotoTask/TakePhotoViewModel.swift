//
//  TakePhotoViewModel.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import SwiftUI
import Combine

class TakePhotoViewModel: BaseViewModel {
    @Published var takePhoto: TakePhoto?
    @Published var isLoading: Bool = true
    @Published var capturedImage: UIImage?
    @Published var showResultModal: Bool = false

    private let dataManager = TakePhotoDataManager()
    var activityId: String
    private var appState: AppState

    init(activityId: String, appState: AppState) {
        self.activityId = activityId
        self.appState = appState
        super.init()
        fetchUserProfile()
        fetchTakePhoto()
        fetchAvailableLanguages()
    }
    /*
    func fetchTakePhoto() {
        isLoading = true
        dataManager.fetchTakePhotoById(activityId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { takePhoto in
                self.takePhoto = takePhoto
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
     */
    func fetchTakePhoto() {
        if activityId == "daily_003" {
            // Simulación de contenido sin Firestore
            self.takePhoto = TakePhoto(
                id: "daily_003",
                province: "Sin provincia",
                question: "Haz un retrato de ti mismo en papel. Luego sácale una foto y súbela aquí.",
                customMessage: "",
                correctAnswerMessage: "¡Bien hecho! Has subido tu retrato.",
                incorrectAnswerMessage: "Parece que no se ha tomado una foto.",
                isCapital: false,
                challenge: "dailyChallenge",
                informationDetail: "Esta actividad estimula la autoexpresión y creatividad. Muy útil para la memoria emocional."
            )

            self.isLoading = false
            return
        }

        // Llamada original (solo si no es tarea diaria)
        isLoading = true
        dataManager.fetchTakePhotoById(activityId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { takePhoto in
                self.takePhoto = takePhoto
                self.isLoading = false
            }
            .store(in: &cancellables)
    }

    /*
    func checkTakePhoto(isCorrect: Bool) {
        guard let takePhoto = takePhoto else { return }

        if isCorrect && capturedImage != nil {
            alertMessage = takePhoto.correctAnswerMessage
            updateUserTask(takePhoto: takePhoto)
            updateSpotForUser()
        } else {
            alertMessage = takePhoto.incorrectAnswerMessage
        }

        showResultModal = true
    }
     */
    func checkTakePhoto(isCorrect: Bool) {
        guard let takePhoto = takePhoto else { return }

        if isCorrect && capturedImage != nil {
            alertMessage = takePhoto.correctAnswerMessage

            // ✅ Solo si NO es una tarea diaria
            if takePhoto.id != "daily_003" {
                updateUserTask(takePhoto: takePhoto)
                updateSpotForUser()
            }
        } else {
            alertMessage = takePhoto.incorrectAnswerMessage
        }

        showResultModal = true
    }


    private func updateUserTask(takePhoto: TakePhoto) {
        guard let user = user else { return }

        // Evitar duplicados
        if user.challenges[takePhoto.challenge]?.contains(takePhoto.id) == true {
            print("Task ID already exists, not adding again.")
            return
        }

        updateTaskForUser(taskID: takePhoto.id, challenge: takePhoto.challenge)
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
