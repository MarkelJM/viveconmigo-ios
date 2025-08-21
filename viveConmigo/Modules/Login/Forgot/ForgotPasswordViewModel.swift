//
//  ForgotPasswordViewModel.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//


import Foundation
import Combine

class ForgotPasswordViewModel: ObservableObject {
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var showSuccessMessage: Bool = false
    
    private let dataManager = ForgotPasswordDataManager()
    private var cancellables = Set<AnyCancellable>()

    func resetPassword(email: String) {
        dataManager.resetPassword(email)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                case .finished:
                    self.showSuccessMessage = true
                    self.showError = false
                }
            } receiveValue: {}
            .store(in: &cancellables)
    }
}
