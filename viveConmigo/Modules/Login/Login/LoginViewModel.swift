//
//  LoginViewModel.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//


import Foundation
import Combine
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

    let loginSuccess = PassthroughSubject<Void, Never>()
    
    private let dataManager = LoginDataManager()
    private var cancellables = Set<AnyCancellable>()

    func login() {
        
        
        dataManager.loginUser(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: {
                self.checkOrCreateUserProfile()

            }
            .store(in: &cancellables)
    }
    
    private func checkOrCreateUserProfile() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        dataManager.fetchUserProfile()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    // Si hay un error, intentamos verificar si el error es que el documento no existe
                    self.createDefaultUserProfile(userID: userID)
                case .finished:
                    break
                }
            } receiveValue: { user in
                // Si el perfil ya existe, guardamos el UID en Keychain
                self.saveUserIDToKeychain(userID)
                self.loginSuccess.send(())
            }
            .store(in: &cancellables)
    }

    // Crea un perfil de usuario predeterminado en Firestore si no existe
    private func createDefaultUserProfile(userID: String) {
        guard let email = Auth.auth().currentUser?.email else { return }

        // Crear un perfil con valores predeterminados
        let defaultUser = User(
            id: userID,
            email: email,
            firstName: "Nombre",
            lastName: "Apellido",
            birthDate: Date(),
            postalCode: "00000",
            city: "Ciudad",
            province: .other,
            avatar: .boy,
            spotIDs: [],
            specialRewards: [:],
            challenges: ["retoBasico": []]
        )

        dataManager.createUserProfile(user: defaultUser)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: {
                self.saveUserIDToKeychain(userID)
                self.loginSuccess.send(())
            }
            .store(in: &cancellables)
    }

    // Guardar el UID en Keychain
    private func saveUserIDToKeychain(_ userID: String) {
        KeychainManager.shared.save(key: "userUID", value: userID)
    }
}

