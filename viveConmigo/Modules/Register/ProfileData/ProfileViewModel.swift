//
//  ProfileViewModel.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//

import Foundation
import Combine
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var birthDate: Date = Date()
    @Published var postalCode: String = ""
    @Published var city: String = ""
    @Published var province: Province = .other
    @Published var avatar: Avatar = .boy
    @Published var spotIDs: [String] = []
    @Published var specialRewards: [String: String] = [:]
    @Published var challenges: [String: [String]] = [:]
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

    private let dataManager = ProfileDataManager()
    private var cancellables = Set<AnyCancellable>()

    func saveUserProfile(completion: @escaping () -> Void) {
        
        
        self.birthDate = Calendar.current.startOfDay(for: Date())
        
        
        guard let email = Auth.auth().currentUser?.email else {
            showError = true
            errorMessage = "Email no encontrado."
            return
        }
        guard validatePostalCode() else {
            showError = true
            errorMessage = "El código postal debe ser un número de 5 dígitos."
            return
        }
        
        guard validateCity() else {
            showError = true
            errorMessage = "La ciudad solo puede contener letras."
            return
        }
        
        if challenges["retoBasico"] == nil {
            challenges["retoBasico"] = []
        }

        let user = User(
            id: UUID().uuidString,
            email: email,
            firstName: firstName,
            lastName: lastName,
            birthDate: birthDate,
            postalCode: postalCode,
            city: city,
            province: province,
            avatar: avatar,
            spotIDs: spotIDs,
            specialRewards: specialRewards,
            challenges: challenges
        )
        
        dataManager.createUserProfile(user: user)
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
                completion()
            }
            .store(in: &cancellables)
    }

    func fetchUserProfile() {
        dataManager.fetchUserProfile()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { user in
                self.email = user.email
                self.firstName = user.firstName
                self.lastName = user.lastName
                self.birthDate = user.birthDate
                self.postalCode = user.postalCode
                self.city = user.city
                self.province = user.province
                self.avatar = user.avatar
                self.spotIDs = user.spotIDs
                self.specialRewards = user.specialRewards
                self.challenges = user.challenges

                if self.challenges["retoBasico"] == nil {
                    self.challenges["retoBasico"] = []
                }
            }
            .store(in: &cancellables)
    }
    
    func validatePostalCode() -> Bool {
        let postalCodePattern = "^[0-9]{5}$"
        return postalCode.range(of: postalCodePattern, options: .regularExpression) != nil
    }

    func validateCity() -> Bool {
        let cityPattern = "^[A-Za-záéíóúÁÉÍÓÚñÑ\\s]+$"
        return city.range(of: cityPattern, options: .regularExpression) != nil
    }
    
    func setRegistrationDateToToday() {
        let today = Calendar.current.startOfDay(for: Date())
        self.birthDate = today
    }

}
