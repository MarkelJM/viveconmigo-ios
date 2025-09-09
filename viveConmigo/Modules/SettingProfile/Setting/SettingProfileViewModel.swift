//
//  SettingProfileViewModel.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import SwiftUI
import Combine
import FirebaseAuth

class SettingProfileViewModel: BaseViewModel {
    @Published var editedFirstName: String = ""
    @Published var editedLastName: String = ""
    @Published var editedPostalCode: String = ""
    @Published var editedCity: String = ""
    @Published var editedProvince: Province = .other
    @Published var editedAvatar: Avatar = .boy
    @Published var isEditing = false
    @Published var isSoundEnabled: Bool = true

    //private let userDefaultsManager = UserDefaultsManager()

    override init() {
        super.init()
        self.isSoundEnabled = userDefaultsManager.isSoundEnabled()
    }

    func toggleSoundEnabled() {
        isSoundEnabled.toggle()  // Cambiar el estado actual
        userDefaultsManager.setSoundEnabled(isSoundEnabled)
    }

    func startEditing() {
        guard let user = user else { return }
        editedFirstName = user.firstName
        editedLastName = user.lastName
        editedPostalCode = user.postalCode
        editedCity = user.city
        editedProvince = user.province
        editedAvatar = user.avatar
    }

    func saveProfileChanges() {
        guard var user = user else { return }
        user.firstName = editedFirstName
        user.lastName = editedLastName
        user.postalCode = editedPostalCode
        user.city = editedCity
        user.province = editedProvince
        user.avatar = editedAvatar

        performProfileUpdate(user: user)
    }

    private func performProfileUpdate(user: User) {
        firestoreManager.updateUserProfile(user: user)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertMessage = "Error al actualizar el perfil: \(error.localizedDescription)"
                case .finished:
                    self.alertMessage = "Perfil actualizado correctamente."
                }
                self.showAlert = true
            } receiveValue: { _ in
                self.isEditing = false
            }
            .store(in: &cancellables)
    }
    
    func deleteAccount() {
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                self.alertMessage = "Error al eliminar la cuenta: \(error.localizedDescription)"
                self.showAlert = true
            } else {
                self.alertMessage = "Cuenta eliminada correctamente."
                self.showAlert = true
                
            }
        }
    }
}
