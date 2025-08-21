//
//  ChallengeListViewModel.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import SwiftUI
import Combine

class ChallengeListViewModel: BaseViewModel {
    @Published var challenges: [Challenge] = []
    @Published var selectedChallengeId: String?
    @Published var isUserLoaded: Bool = false

    private let dataManager = ChallengeListDataManager()

    override init() {
        super.init()
        fetchUserProfile()
    }
    
    override func fetchUserProfile() {
        super.fetchUserProfile()
        self.$user
            .compactMap { $0 }
            .sink { [weak self] user in
                print("User loaded: \(String(describing: user))")
                self?.isUserLoaded = true
            }
            .store(in: &self.cancellables)
    }
    
    func fetchChallenges() {
        dataManager.fetchChallenges()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error in fetchChallenges: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                case .finished:
                    print("Finished fetching challenges.")
                }
            } receiveValue: { challenges in
                //print("Challenges received: \(challenges)")
                self.challenges = challenges
            }
            .store(in: &self.cancellables)
    }
    
    func completedTasks(for challengeName: String) -> Int {
        guard let user = user else { return 0 }
        return user.challenges[challengeName]?.count ?? 0
    }

    func selectChallenge(_ challenge: Challenge) {
        print("Selected challenge: \(challenge)")
        self.selectedChallengeId = challenge.id
        userDefaultsManager.saveChallengeName(challenge.challengeName)
    }

    func isChallengeAlreadyBegan(challengeName: String) -> Bool {
        guard let user = user else { return false }
        let hasBegan = user.challenges[challengeName] != nil
        print("Challenge \(challengeName) already began: \(hasBegan)")
        return hasBegan
    }
}
