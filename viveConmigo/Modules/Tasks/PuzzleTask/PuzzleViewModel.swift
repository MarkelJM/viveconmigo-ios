//
//  PuzzleViewModel.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import SwiftUI
import Combine

class PuzzleViewModel: BaseViewModel {
    @Published var puzzles: [Puzzle] = []
    @Published var isLoading: Bool = true
    @Published var droppedPieces: [String: CGPoint] = [:]
    @Published var draggingPiece: String?
    @Published var showResultSheet: Bool = false
    @Published var showTranslationSheet: Bool = false

    
    private let dataManager = PuzzleDataManager()
    var activityId: String
    private var appState: AppState


    init(activityId: String, appState: AppState) {
        self.activityId = activityId
        self.appState = appState
        super.init()
        fetchUserProfile()
        fetchAvailableLanguages()
     }
    
    func fetchPuzzle() {
        isLoading = true
        dataManager.fetchPuzzleById(activityId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { puzzle in
                self.puzzles = [puzzle]
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func updateDraggedPiecePosition(to location: CGPoint, key: String) {
        droppedPieces[key] = location
        print("Updated position for piece \(key): \(location)")
    }

    func dropPiece() {
        draggingPiece = nil
        print("Piece dropped")
    }

    func selectPiece(key: String) {
        droppedPieces[key] = CGPoint(x: 150, y: 150)
        print("Piece \(key) selected and moved to (150, 150)")
    }
    
    func checkPuzzle() {
        guard let puzzle = puzzles.first else { return }
        var isCorrect = true
        
        for (key, correctPosition) in puzzle.correctPositions {
            if let currentPosition = droppedPieces[key] {
                let tolerance: CGFloat = 500.0
                let correctX = correctPosition.x * 500
                let correctY = correctPosition.y * 500
                let differenceX = abs(currentPosition.x - correctX)
                let differenceY = abs(currentPosition.y - correctY)

                if differenceX > tolerance || differenceY > tolerance {
                    isCorrect = false
                    break
                }
            } else {
                isCorrect = false
                break
            }
            
            showResultSheet = true

        }
        
        if isCorrect {
            alertMessage = puzzle.correctAnswerMessage
            updateUserTask(puzzle: puzzle)
        } else {
            alertMessage = puzzle.incorrectAnswerMessage
        }
        
        //showSheet = true
    }
    
    private func updateUserTask(puzzle: Puzzle) {
        updateTaskForUser(taskID: puzzle.id, challenge: puzzle.challenge)
        updateSpotForUser()
    }

    private func updateTaskForUser(taskID: String, challenge: String) {
        guard let user = user else { return }

        // Evitar duplicados
        if user.challenges[challenge]?.contains(taskID) == true {
            print("Task ID already exists, not adding again.")
            return
        }

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
