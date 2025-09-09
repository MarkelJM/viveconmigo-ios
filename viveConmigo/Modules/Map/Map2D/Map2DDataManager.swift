//
//  Map2DDataManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import Foundation
import Combine

class MapDataManager {
    private let firestoreManager = MapFirestoreManager()
    
    func fetchSpots(for challengeName: String) -> AnyPublisher<[Spot], Error> {
        return firestoreManager.fetchSpots(for: challengeName)
    }

    func fetchChallenges() -> AnyPublisher<[Challenge], Error> {
        return firestoreManager.fetchChallenges()
    }

    func fetchChallengeReward(for challengeName: String) -> AnyPublisher<ChallengeReward, Error> {
        return firestoreManager.fetchChallengeReward(for: challengeName)
    }
}
