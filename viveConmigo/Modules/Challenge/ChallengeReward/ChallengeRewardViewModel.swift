//
//  ChallengeRewardViewModel.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import SwiftUI
import Combine

class ChallengeRewardViewModel: BaseViewModel {
    @Published var challengeReward: ChallengeReward?
    @Published var isLoading: Bool = true
    @Published var showResultModal: Bool = false
    @Published var resultMessage: String = ""

    private let dataManager = ChallengeRewardDataManager()
    private var activityId: String

    init(activityId: String) {
        self.activityId = activityId
        super.init()
        fetchUserProfile()
        fetchChallengeRewardById(activityId)
    }
    
    func fetchChallengeRewardById(_ id: String) {
        isLoading = true
        print("Fetching challenge reward with ID: \(id)")
        dataManager.fetchChallengeRewardById(id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Error fetching challenge reward: \(error.localizedDescription)")
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { reward in
                self.challengeReward = reward
                self.isLoading = false
                print("Challenge reward fetched: \(reward)")
            }
            .store(in: &cancellables)
    }
    
    func completeRewardTask() {
        guard let reward = challengeReward else {
            print("No challenge reward found to complete task.")
            return
        }
        
        print("Completing reward task for reward: \(reward)")
        
        if let user = user {
            let challengeName = userDefaultsManager.getChallengeName() ?? reward.challenge
            var updatedRewards = user.specialRewards
            updatedRewards[challengeName] = reward.prizeImage
            
            firestoreManager.updateSpecialRewardsForUser(updatedRewards)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        self.alertMessage = "Error añadiendo el premio especial: \(error.localizedDescription)"
                        self.showAlert = true
                        print("Error adding special reward: \(error.localizedDescription)")
                    case .finished:
                        break
                    }
                } receiveValue: { _ in
                    print("Special reward added to user in Firestore")
                }
                .store(in: &cancellables)
        }

        updateTaskForUser(taskID: reward.id, challenge: reward.challenge)
        updateSpotForUser()

        self.resultMessage = reward.correctAnswerMessage
        self.showResultModal = true
        print("Reward task completed, result message set: \(reward.correctAnswerMessage)")
    }

    private func updateTaskForUser(taskID: String, challenge: String) {
        print("Updating task for user with task ID: \(taskID) and challenge: \(challenge)")
        firestoreManager.updateUserTaskIDs(taskID: taskID, challenge: challenge)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertMessage = "Error actualizando la tarea: \(error.localizedDescription)"
                    self.showAlert = true
                    print("Error updating user task: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { _ in
                print("User task updated in Firestore")
            }
            .store(in: &cancellables)
    }

    private func updateSpotForUser() {
        if let spotID = userDefaultsManager.getSpotID() {
            print("Updating spot for user with spot ID: \(spotID)")
            firestoreManager.updateUserSpotIDs(spotID: spotID)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        self.alertMessage = "Error actualizando el spot: \(error.localizedDescription)"
                        self.showAlert = true
                        print("Error updating user spot: \(error.localizedDescription)")
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
