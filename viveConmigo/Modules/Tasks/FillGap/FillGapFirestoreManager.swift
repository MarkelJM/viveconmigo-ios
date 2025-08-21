//
//  FillGapFirestoreManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//

import Foundation

import Foundation
import Combine
import FirebaseFirestore

class FillGapFirestoreManager {
    private let db = Firestore.firestore()
    
    func fetchFillGapById(_ id: String) -> AnyPublisher<FillGap, Error> {
        Future { promise in
            self.db.collection("fillGap").document(id).getDocument { document, error in
                if let document = document, document.exists, let data = document.data() {
                    if let fillGap = FillGap(from: data) {
                        promise(.success(fillGap))
                    } else {
                        promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode fillGap"])))
                    }
                } else {
                    promise(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
