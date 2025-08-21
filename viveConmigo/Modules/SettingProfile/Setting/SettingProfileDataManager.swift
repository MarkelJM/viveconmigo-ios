//
//  SettingProfileDataManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import Foundation
import Combine

class SettingProfileDataManager {
    private let firestoreManager = SettingProfileFirestoreManager()

    func fetchUserProfile() -> AnyPublisher<User, Error> {
        return firestoreManager.fetchUserProfile()
    }
    
    func updateUserProfile(user: User) -> AnyPublisher<Void, Error> {
        return firestoreManager.updateUserProfile(user: user)
    }
}
