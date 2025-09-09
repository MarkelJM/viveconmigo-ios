//
//  ForgotPasswordDataManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//


import SwiftUI
import Combine

class ForgotPasswordDataManager {
    private let firestoreManager = FirestoreManager()
    
    func resetPassword(_ email: String) -> AnyPublisher<Void, Error> {
        return firestoreManager.resetPassword(email: email)
    }
}
