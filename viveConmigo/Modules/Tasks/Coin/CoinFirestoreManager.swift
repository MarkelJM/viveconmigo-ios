//
//  CoinFirestoreManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import Foundation
import Combine
import FirebaseFirestore

class CoinFirestoreManager {
    private let db = Firestore.firestore()

    func fetchCoinById(_ id: String) -> AnyPublisher<Coin, Error> {
        Future { promise in
            self.db.collection("coins").document(id).getDocument { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else if let data = snapshot?.data(), let coin = Coin(from: data) {
                    promise(.success(coin))
                } else {
                    promise(.failure(NSError(domain: "Document not found", code: 404, userInfo: nil)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
}
