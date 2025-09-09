//
//  Map3DDataManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import FirebaseFunctions
import Foundation
import Combine

class Map3DDataManager {
    private lazy var functions = Functions.functions()
    
    private let firestoreManager = MapFirestoreManager()
    
    func fetchSpots(for challengeName: String) -> AnyPublisher<[Spot], Error> {
        return firestoreManager.fetchSpots(for: challengeName)
    }

    func fetchChallenges() -> AnyPublisher<[Challenge], Error> {
        return firestoreManager.fetchChallenges()
    }

    func fetchChallengeReward(for challengeName: String) -> AnyPublisher<ChallengeReward, Error> {
        return firestoreManager.fetchChallengeReward(for: challengeName)
    }
    
    func getMapboxToken() -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            self.functions.httpsCallable("getMapboxToken").call { result, error in
                if let error = error {
                    print("Error al obtener el token de Mapbox: \(error.localizedDescription)")
                    promise(.failure(error))
                    return
                }

                guard let data = result?.data else {
                    print("No hay datos disponibles en la respuesta")
                    promise(.failure(NSError(domain: "DataUnavailable", code: -1, userInfo: [NSLocalizedDescriptionKey: "No hay datos disponibles"])))
                    return
                }

                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    if let tokenDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                       let token = tokenDict["token"] as? String {
                        print("Token de Mapbox recibido: \(token)")
                        promise(.success(token))
                    } else {
                        throw NSError(domain: "TokenParsing", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token no encontrado en la respuesta"])
                    }
                } catch {
                    print("Error al decodificar el token: \(error)")
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
