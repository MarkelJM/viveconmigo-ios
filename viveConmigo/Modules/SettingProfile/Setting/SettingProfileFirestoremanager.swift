//
//  SettingProfileFirestoremanager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import Foundation
import FirebaseFirestore
import Combine
import FirebaseAuth

class SettingProfileFirestoreManager {
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    // Fetch user profile from Firestore
    func fetchUserProfile() -> AnyPublisher<User, Error> {
        Future { promise in
            guard let uid = self.auth.currentUser?.uid else {
                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }
            
            self.db.collection("users").document(uid).getDocument { document, error in
                if let error = error {
                    promise(.failure(error))
                } else if let document = document, document.exists {
                    let data = document.data() ?? [:]
                    if let user = User(from: data) {
                        promise(.success(user))
                    } else {
                        promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode user"])))
                    }
                } else {
                    promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    // Update user profile in Firestore
    func updateUserProfile(user: User) -> AnyPublisher<Void, Error> {
        Future { promise in
            guard let uid = self.auth.currentUser?.uid else {
                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
                return
            }
            
            let userData = user.toFirestoreData()
            
            self.db.collection("users").document(uid).setData(userData) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
