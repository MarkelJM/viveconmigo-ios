//
//  RegisterDataManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import Foundation
import Combine

class RegisterDataManager {
    private let firestoreManager = FirestoreManager()
    
    func registerUser(email: String, password: String) -> AnyPublisher<Void, Error> {
        firestoreManager.registerUser(email: email, password: password)
    }
    
    func sendEmailVerification() -> AnyPublisher<Void, Error> {
        firestoreManager.sendEmailVerification()
    }
    
    func checkEmailVerification() -> AnyPublisher<Bool, Error> {
        firestoreManager.checkEmailVerification()
    }
}
