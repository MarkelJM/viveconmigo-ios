//
//  ChallengeListDataManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import Combine

class ChallengeListDataManager {
    private let firestoreManager = ChallengeListFirestoreManager()

    func fetchChallenges() -> AnyPublisher<[Challenge], Error> {
        return firestoreManager.fetchChallenges()
    }
}
