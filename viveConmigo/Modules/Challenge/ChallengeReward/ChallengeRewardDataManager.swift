//
//  ChallengeRewardDataManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import Combine
import FirebaseFirestore

class ChallengeRewardDataManager {
    private let firestoreManager = ChallengeRewardFirestoreManager()
    
    func fetchChallengeRewardById(_ id: String) -> AnyPublisher<ChallengeReward, Error> {
        return firestoreManager.fetchChallengeRewardById(id)
    }
}
