//
//  CoinDataManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import Combine
import FirebaseFirestore


class CoinDataManager {
    private let firestoreManager = CoinFirestoreManager()
    
    func fetchCoinById(_ id: String) -> AnyPublisher<Coin, Error> {
        return firestoreManager.fetchCoinById(id)
    }
    

}
