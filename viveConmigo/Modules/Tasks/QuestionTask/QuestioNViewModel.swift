//
//  QuestioNViewModel.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import SwiftUI
import Combine

class QuestionAnswerViewModel: BaseViewModel {
    @Published var questionAnswer: QuestionAnswer?
    @Published var isLoading: Bool = true
    @Published var selectedOption: String?
    @Published var showResultModal: Bool = false
    
    private let dataManager = QuestionAnswerDataManager()
    var activityId: String
    private var appState: AppState

    init(activityId: String, appState: AppState) {
        self.activityId = activityId
        self.appState = appState // Asignar appState
        super.init()
        fetchUserProfile() // Cargar el perfil del usuario cuando se crea el ViewModel
        fetchQuestionAnswer()
        fetchAvailableLanguages()
    }
    
    /*
    func fetchQuestionAnswer() {
        isLoading = true
        dataManager.fetchQuestionAnswerById(activityId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { questionAnswer in
                self.questionAnswer = questionAnswer
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
     */
    
    func fetchQuestionAnswer() {
        if activityId == "daily_001" {
            // ✅ Pregunta local
            self.questionAnswer = QuestionAnswer(
                id: "daily_001",
                province: "Navarra",
                question: "¿Cuál es la capital de Navarra?",
                options: ["Pamplona", "Logroño", "Bilbao", "San Sebastián"],
                correctAnswer: "Pamplona",
                customMessage: "",
                correctAnswerMessage: "¡Correcto! Pamplona es la capital de Navarra.",
                incorrectAnswerMessage: "Incorrecto. La respuesta correcta es Pamplona.",
                isCapital: true,
                challenge: "dailyChallenge",
                informationDetail: "Pamplona es la capital de la Comunidad Foral de Navarra, conocida por los Sanfermines."
            )
            self.isLoading = false
            return
        }

        // 🔁 Lógica original con llamada al API
        isLoading = true
        dataManager.fetchQuestionAnswerById(activityId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { questionAnswer in
                self.questionAnswer = questionAnswer
                self.isLoading = false
            }
            .store(in: &cancellables)
    }

    
    func checkAnswer() {
        guard let questionAnswer = questionAnswer else { return }
        
        if selectedOption == questionAnswer.correctAnswer {
            alertMessage = questionAnswer.correctAnswerMessage
            updateUserTask(questionAnswer: questionAnswer)
            updateSpotForUser()
        } else {
            alertMessage = questionAnswer.incorrectAnswerMessage
        }
        
        showResultModal = true
    }
    
    private func updateUserTask(questionAnswer: QuestionAnswer) {
        guard let user = user else { return }

        // Evitar duplicados en Firestore
        if user.challenges[questionAnswer.challenge]?.contains(questionAnswer.id) == true {
            print("Task ID already exists, not adding again.")
            return
        }

        updateTaskForUser(taskID: questionAnswer.id, challenge: questionAnswer.challenge)
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
