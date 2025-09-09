//
//  AppState.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 9/3/25.
//


import Foundation
import Combine

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentView: AppView = .icon {
        didSet {
            print("Current view is now \(currentView)")
        }
    }

    enum AppView: Equatable {
        case icon
        case registerEmail
        case emailVerification
        case login
        case profile
        case map
        case map3D
        case mapContainer
        case challengeList
        case avatarSelection
        case puzzle(id: String)
        case coin(id: String)
        case dates(id: String)
        case fillGap(id: String)
        case questionAnswer(id: String)
        case takePhoto(id: String)
        case onboardingOne
        case onboardingTwo
        case forgotPassword
        case termsAndConditions
        case challengePresentation(challengeName: String)
        case settings
        case challengeReward(challengeName: String)
        case dailyTask
        case dailyWalking
        //case bic

    }
}
