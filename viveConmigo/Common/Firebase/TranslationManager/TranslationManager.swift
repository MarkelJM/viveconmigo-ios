//
//  TranslationManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import Foundation
import FirebaseFirestore
import Combine

class TranslationDataManager {
    private let db = Firestore.firestore()

    // Obtener los idiomas disponibles (documentos en la colección 'translate')
    func fetchAvailableLanguages() -> AnyPublisher<[String], Error> {
        Future { promise in
            self.db.collection("translate").getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else if let documents = snapshot?.documents {
                    let languages = documents.map { $0.documentID }  // Extraer los IDs de los documentos
                    promise(.success(languages))
                } else {
                    promise(.failure(NSError(domain: "No languages found", code: 404, userInfo: nil)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Obtener la traducción para una actividad en base a Euskera
    func fetchTranslationForActivity(activityId: String) -> AnyPublisher<Translation, Error> {
        Future { promise in
            print("Buscando traducción para la actividad ID: \(activityId) en Euskera")  // Agregamos el print del activityId

            let docRef = self.db.collection("translate").document("Euskera").collection("activities").document(activityId)

            docRef.getDocument { document, error in
                if let error = error {
                    print("Error al obtener la traducción: \(error.localizedDescription)")
                    promise(.failure(error))
                } else if let data = document?.data(), let translation = Translation(from: data) {
                    print("Traducción encontrada: \(translation.text)")
                    promise(.success(translation))
                } else {
                    print("No se encontró la traducción para la actividad \(activityId) en Euskera")
                    promise(.failure(NSError(domain: "Document not found", code: 404, userInfo: nil)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
