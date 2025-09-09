//
//  DatesOrderFirestoreManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//

import Foundation

import Foundation
import Combine
import FirebaseFirestore

class DatesOrderFirestoreManager {
    private let db = Firestore.firestore()
    
    func fetchDateEventById(_ id: String) -> AnyPublisher<DateEvent, Error> {
        print("Fetching DateEvent with ID: \(id)")
        
        return Future { promise in
            self.db.collection("dates").document(id).getDocument { document, error in
                if let error = error {
                    print("Error fetching document: \(error.localizedDescription)")
                    promise(.failure(error))
                } else if let document = document, document.exists {
                    print("Document data: \(document.data() ?? [:])")
                    if let dateEvent = DateEvent(from: document.data() ?? [:]) {
                        print("Successfully decoded DateEvent")
                        promise(.success(dateEvent))
                    } else {
                        print("Failed to decode DateEvent from document data")
                        promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode dateEvent"])))
                    }
                } else {
                    print("Document does not exist for ID: \(id)")
                    promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
