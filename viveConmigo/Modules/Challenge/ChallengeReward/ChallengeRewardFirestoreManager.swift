//
//  ChallengeRewardFirestoreManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import Foundation
import Combine
import FirebaseFirestore

class ChallengeRewardFirestoreManager {
    private let db = Firestore.firestore()

    func fetchChallengeRewardById(_ id: String) -> AnyPublisher<ChallengeReward, Error> {
        Future { promise in
            self.db.collection("challengeReward").document(id).getDocument { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else if let data = snapshot?.data(), let reward = ChallengeReward(from: data) {
                    promise(.success(reward))
                } else {
                    promise(.failure(NSError(domain: "Document not found challenge Reward", code: 404, userInfo: nil)))
                }
            }
        }
        .eraseToAnyPublisher()
    }


}
