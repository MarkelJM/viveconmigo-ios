//
//  Map3DFirestoreManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import FirebaseFirestore
import Combine

class Map3DFirestoreManager {
    private var db = Firestore.firestore()
    
    func fetchSpots(for challengeName: String) -> AnyPublisher<[Spot], Error> {
        Future { promise in
            self.db.collection("spots")
                .document(challengeName)
                .collection("locationsSpot")
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        let spots = querySnapshot?.documents.compactMap { document in
                            Spot(from: document.data())
                        } ?? []
                        promise(.success(spots))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchChallenges() -> AnyPublisher<[Challenge], Error> {
        Future { promise in
            self.db.collection("challengeEuskadi")
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        let challenges = querySnapshot?.documents.compactMap { document in
                            Challenge(from: document.data())
                        } ?? []
                        promise(.success(challenges))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchChallengeReward(for challengeName: String) -> AnyPublisher<ChallengeReward, Error> {
        Future { promise in
            self.db.collection("challengeReward")
                .document(challengeName)
                .getDocument { document, error in
                    if let document = document, document.exists {
                        if let rewardData = document.data(), let reward = ChallengeReward(from: rewardData) {
                            promise(.success(reward))
                        } else {
                            promise(.failure(NSError(domain: "Error decoding reward", code: -1, userInfo: nil)))
                        }
                    } else {
                        promise(.failure(error ?? NSError(domain: "Document does not exist", code: -1, userInfo: nil)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
