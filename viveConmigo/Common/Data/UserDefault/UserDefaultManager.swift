//
//  UserDefaultManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//


import Foundation

class UserDefaultsManager {
    private let spotIDKey = "spotID"
    private let challengeNameKey = "challengeName"
    private let soundEnabledKey = "soundEnabled"
    
    func setSoundEnabled(_ isEnabled: Bool) {
        UserDefaults.standard.set(isEnabled, forKey: soundEnabledKey)
    }
    
    func isSoundEnabled() -> Bool {
        if UserDefaults.standard.object(forKey: soundEnabledKey) == nil {
            // Si no se ha guardado el valor antes, lo activamos por defecto
            return true
        }
        return UserDefaults.standard.bool(forKey: soundEnabledKey)
    }


    func saveSpotID(_ id: String) {
        UserDefaults.standard.set(id, forKey: spotIDKey)
    }

    func getSpotID() -> String? {
        return UserDefaults.standard.string(forKey: spotIDKey)
    }

    func clearSpotID() {
        UserDefaults.standard.removeObject(forKey: spotIDKey)
    }

    func saveChallengeName(_ name: String) {
        UserDefaults.standard.set(name, forKey: challengeNameKey)
    }

    func getChallengeName() -> String? {
        return UserDefaults.standard.string(forKey: challengeNameKey)
    }

    func clearChallengeName() {
        UserDefaults.standard.removeObject(forKey: challengeNameKey)
    }
    
    
}
