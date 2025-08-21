//
//  NavigationState.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 9/3/25.
//



import SwiftUI

struct NavigationState: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var registerViewModel = RegisterViewModel()
    @State private var selectedSpot: Spot? = nil
    @State private var selectedReward: ChallengeReward? = nil

    private var shouldShowTabBar: Bool {
        switch appState.currentView {
        case .mapContainer, .challengeList, .settings:
            return true
        default:
            return false
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Colocar el CustomTabBar en la parte superior
            if shouldShowTabBar {
                CustomTabBar(selectedTab: $appState.currentView)
                    .zIndex(1)  // Asegura que el CustomTabBar esté por encima de otras vistas
            }

            
            // Espacio para el contenido
            Spacer(minLength: 0)
            
            // Vista principal
            currentView()
                .zIndex(0)
                .padding(.top, 0) // Para que el contenido no se superponga al CustomTabBar
        }
        //.edgesIgnoringSafeArea(.top) // Ignorar las áreas seguras para el tab bar
        .padding(.top, 50)
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            print("Current AppState in NavigationState: \(appState.currentView)")
        }
    }


    @ViewBuilder
    private func currentView() -> some View {
        switch appState.currentView {
        case .icon:
            IconView()
        case .registerEmail:
            RegisterView(viewModel: registerViewModel)
        case .emailVerification:
            VerificationEmailView(viewModel: RegisterViewModel())
        case .login:
            LoginView(viewModel: LoginViewModel())
        case .profile:
            ProfileView(viewModel: ProfileViewModel())
        case .mapContainer:
            MapContainerView().environmentObject(appState)
        case .map:
            Map2DView()
        case .map3D:
            Map3DView(
                selectedSpot: $selectedSpot,
                selectedReward: $selectedReward,
                viewModel: Map3DViewModel(appState: appState)
            )
        case .challengeList:
            ChallengeListView()
        case .avatarSelection:
            AvatarSelectionView(selectedAvatar: .constant(.boy))
        case .challengeReward(let challengeName):
            ChallengeRewardView(viewModel: ChallengeRewardViewModel(activityId: challengeName))
        case .puzzle(let id):
            PuzzleView(viewModel: PuzzleViewModel(activityId: id, appState: appState))
        case .coin(let id):
            CoinView(viewModel: CoinViewModel(activityId: id, appState: appState))
        case .dates(let id):
            DatesOrderView(viewModel: DatesOrderViewModel(activityId: id, appState: appState))
        case .fillGap(let id):
            FillGapView(viewModel: FillGapViewModel(activityId: id, appState: appState))

        case .questionAnswer(let id):
            QuestionAnswerView(viewModel: QuestionAnswerViewModel(activityId: id, appState: appState))
        case .takePhoto(let id):
            TakePhotoView(viewModel: TakePhotoViewModel(activityId: id, appState: appState))
        case .onboardingOne:
            OnboardingOneView()
        case .onboardingTwo:
            OnboardingTwoView()
        case .forgotPassword:
            ForgotPasswordView(viewModel: ForgotPasswordViewModel())
        case .termsAndConditions:
            TermsAndConditionsView(agreeToTerms: $registerViewModel.agreeToTerms)
        case .challengePresentation(let challengeName):
            ChallengePresentationView(viewModel: ChallengePresentationViewModel(challengeName: challengeName))
        case .settings:
            SettingProfileView()
        case .dailyTask:
            DailyTaskView()
        case .dailyWalking:
            WalkingTaskView()
        //case .bic:
            //BICView()
    
        }
    }
}
