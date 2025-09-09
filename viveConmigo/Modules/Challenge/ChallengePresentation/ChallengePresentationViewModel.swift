//
//  ChallengePresentationViewModel.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import SwiftUI
import Combine

class ChallengePresentationViewModel: BaseViewModel {
    @Published var challenge: Challenge?
    private let dataManager = ChallengePresentationDataManager()
    private var challengeName: String

    init(challengeName: String) {
        self.challengeName = challengeName
        super.init()
        fetchChallenge()
        fetchUserProfile()
    }

    var userAvatar: String {
        user?.avatar.rawValue ?? "defaultAvatar"
    }

    func beginChallenge() -> AnyPublisher<Void, Error> {
        guard let challenge = challenge, var user = user else {
            return Fail(error: NSError(domain: "No user or challenge available", code: -1, userInfo: nil))
                .eraseToAnyPublisher()
        }

        // Asegúrate de que el desafío esté en el perfil del usuario si no está ya
        if user.challenges[challengeName] == nil {
            user.challenges[challengeName] = [] // Inicializa con un array vacío
        }

        // Guarda el nombre del desafío en UserDefaults
        userDefaultsManager.saveChallengeName(challengeName)

        // Guarda el estado del desafío en Firestore
        return saveUserChallengeState(user: user)
            .handleEvents(receiveOutput: {
                print("Challenge state saved in Firestore")
            })
            .eraseToAnyPublisher()
    }

    private func saveUserChallengeState(user: User) -> AnyPublisher<Void, Error> {
        return firestoreManager.updateUserChallenges(user: user)
    }

    private func fetchChallenge() {
        dataManager.fetchChallengeByName(challengeName)
            .receive(on: DispatchQueue.main)
            .sink { completionResult in
                switch completionResult {
                case .failure(let error):
                    self.alertMessage = "Error loading challenge: \(error.localizedDescription)"
                    self.showAlert = true
                case .finished:
                    break
                }
            } receiveValue: { [weak self] challenge in
                self?.challenge = challenge
            }
            .store(in: &cancellables)
    }
}
