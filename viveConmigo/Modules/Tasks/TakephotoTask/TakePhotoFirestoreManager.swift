//
//  TakePhotoFirestoreManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import Foundation
import FirebaseFirestore
import Combine

class TakePhotoFirestoreManager {
    private let db = Firestore.firestore()
    
    func fetchTakePhotoById(_ id: String) -> AnyPublisher<TakePhoto, Error> {
        Future { promise in
            self.db.collection("takePhotos").document(id).getDocument { document, error in
                if let document = document, document.exists, let data = document.data() {
                    if let takePhoto = TakePhoto(from: data) {
                        promise(.success(takePhoto))
                    } else {
                        promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode TakePhoto"])))
                    }
                } else {
                    promise(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
