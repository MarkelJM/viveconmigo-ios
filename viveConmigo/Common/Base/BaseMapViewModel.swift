//
//  BaseMapViewModel.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//


import Foundation
import Combine
import CoreLocation
import MapKit

class BaseMapViewModel: BaseViewModel {
    @Published var spots: [Spot] = []
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var selectedChallenge: String
    @Published var showChallengeSelection: Bool = false
    @Published var isChallengeBegan: Bool = false
    @Published var challenges: [Challenge] = []
    @Published var mapAnnotations: [UnifiedAnnotation] = []
    @Published var userLocationAnnotation: UnifiedAnnotation?
    @Published var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.6528, longitude: -2.7286)
    @Published var zoomLevel: Double = 0.02
    
    var appState: AppState
    private var locationManager = LocationManager()
    private var dataManager = MapDataManager()
    private var hasCenteredOnUser = false

    init(appState: AppState) {
        self.appState = appState
        self.selectedChallenge = "retoBasico"
        super.init()
        self.selectedChallenge = userDefaultsManager.getChallengeName() ?? "retoBasico"
        setupBindings()
        fetchUserProfileAndUpdateState()
        fetchChallenges()
    }

    // Configuración de los bindings y permisos de localización
    private func setupBindings() {
        locationManager.$authorizationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.authorizationStatus = status
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    self?.fetchSpots() // Cargar spots si se permiten las ubicaciones
                } else if status == .denied {
                    self?.errorMessage = "Location permissions denied."
                }
            }
            .store(in: &cancellables)

        locationManager.$location
            .compactMap { $0 }
            .sink { [weak self] location in
                guard let self = self else { return }

                // Centrar solo una vez en la primera ubicación obtenida
                if !self.hasCenteredOnUser {
                    self.centerCoordinate = location.coordinate
                    self.updateRegionWithUserLocation(location.coordinate) // Aquí actualizamos el mapa
                    self.hasCenteredOnUser = true
                }

                let avatarImage = self.user?.avatar.rawValue ?? "defaultAvatar"
                self.userLocationAnnotation = UnifiedAnnotation(userLocation: location.coordinate, avatarImage: avatarImage)

                // Print para verificar la ubicación actualizada
                //print("User location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            }
            .store(in: &cancellables)
    }

    // Cargar el perfil de usuario y actualizar el estado de la vista
    func fetchUserProfileAndUpdateState() {
        super.fetchUserProfile()

        if let user = self.user {
            self.checkChallengeStatus()
        } else {
            self.alertMessage = "Error: No user data found."
            self.showAlert = true
        }
    }

    // Cargar desafíos disponibles
    func fetchChallenges() {
        dataManager.fetchChallenges()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] challenges in
                self?.challenges = challenges
            }
            .store(in: &cancellables)
    }

    // Cargar los spots disponibles para el desafío seleccionado
    func fetchSpots() {
        dataManager.fetchSpots(for: selectedChallenge)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching spots: \(error.localizedDescription)")

                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] spots in
                self?.spots = spots
                print("Spots loaded: \(spots)")  // <-- Añade esto para ver si los spots se están cargando

                self?.addSpotsToMap(spots: spots)
                self?.checkForChallengeCompletionAndAddReward()
            }
            .store(in: &cancellables)
    }

    // Verificar si una tarea (spot) ya ha sido completada
    func isTaskCompleted(spotID: String) -> Bool {
        guard let user = user else { return false }
        return user.spotIDs.contains(spotID)
    }

    // Añadir spots al mapa como anotaciones
    func addSpotsToMap(spots: [Spot]) {
        guard let user = user else { return }

        let completedSpotIDs = user.spotIDs
        print("Adding spots to map, user has completed spots: \(completedSpotIDs.count)")

        for spot in spots {
            print("Processing spot: \(spot.id) - \(spot.name)")

            var annotation = UnifiedAnnotation(spot: spot)

            if completedSpotIDs.contains(spot.id) {
                annotation.image = "checkmark.circle.fill"
            }
            
            mapAnnotations.append(annotation)
        }

        print("Map annotations count after loading spots: \(mapAnnotations.count)")
    }

    // Verificar si se ha completado el desafío y añadir la recompensa
    func checkForChallengeCompletionAndAddReward() {
        guard let user = user else { return }

        if let challenge = challenges.first(where: { $0.challengeName == selectedChallenge }) {
            let completedTasksCount = user.challenges[selectedChallenge]?.count ?? 0
            let tasksRequired = challenge.taskAmount

            print("Completed tasks count: \(completedTasksCount), tasks required: \(tasksRequired)")

            if completedTasksCount >= tasksRequired {
                print("Challenge \(selectedChallenge) completed.")
                fetchChallengeReward(for: selectedChallenge)
            } else {
                print("Challenge \(selectedChallenge) has not been completed yet.")
            }
        }
    }

    // Obtener la recompensa de desafío completado
    func fetchChallengeReward(for challengeName: String) {
        dataManager.fetchChallengeReward(for: challengeName)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] reward in
                print("Reward received: \(reward)")
                self?.addChallengeRewardToMap(reward: reward)
            }
            .store(in: &cancellables)
    }

    // Añadir anotación de la recompensa al mapa
    func addChallengeRewardToMap(reward: ChallengeReward) {
        let annotation = UnifiedAnnotation(reward: reward)
        mapAnnotations.append(annotation)
        print("Added reward annotation. Total annotations: \(mapAnnotations.count)")
    }

    // Método que actualizará la región del mapa basado en la ubicación del usuario. Este será implementado por las subclases.
    func updateRegionWithUserLocation(_ coordinate: CLLocationCoordinate2D) {
        // Será sobreescrito por los submodelos (2D y 3D)
    }

    // Verificar el estado del desafío actual
    func checkChallengeStatus() {
        guard let user = user else { return }
        isChallengeBegan = user.challenges[selectedChallenge] != nil
    }

    // Seleccionar un desafío específico
    func selectChallenge(_ challenge: Challenge) {
        selectedChallenge = challenge.challengeName
        if user?.challenges[selectedChallenge] != nil {
            appState.currentView = .map
        } else {
            appState.currentView = .challengePresentation(challengeName: selectedChallenge)
        }
        userDefaultsManager.saveChallengeName(selectedChallenge)
        showChallengeSelection = false
    }

    // Iniciar el desafío seleccionado
    func beginChallenge() {
        guard var user = user else { return }

        if user.challenges[selectedChallenge] == nil {
            user.challenges[selectedChallenge] = []
            saveUserChallengeState(user: user)
            appState.currentView = .challengePresentation(challengeName: selectedChallenge)
        } else {
            appState.currentView = .map
        }

        userDefaultsManager.saveChallengeName(selectedChallenge)
        isChallengeBegan = true
    }

    // Guardar el estado del desafío del usuario
    private func saveUserChallengeState(user: User) {
        firestoreManager.updateUserChallenges(user: user)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertMessage = "Error: \(error.localizedDescription)"
                    self.showAlert = true
                case .finished:
                    break
                }
            } receiveValue: { _ in
                print("User challenge state successfully updated in Firestore")
            }
            .store(in: &cancellables)
    }

    // Guardar el ID del spot en el almacenamiento local
    func saveSpotID(_ spotID: String) {
        userDefaultsManager.saveSpotID(spotID)
    }
}
