//
//  QuestionFirestoreManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import Foundation
import Combine
import FirebaseFirestore



class QuestionAnswerFirestoreManager {
    private let db = Firestore.firestore()
    
    func fetchQuestionAnswerById(_ id: String) -> AnyPublisher<QuestionAnswer, Error> {
        Future { promise in
            self.db.collection("questionAnswers").document(id).getDocument { document, error in
                if let document = document, document.exists, let data = document.data() {
                    if let questionAnswer = QuestionAnswer(from: data) {
                        promise(.success(questionAnswer))
                    } else {
                        promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode questionAnswers"])))
                    }
                } else {
                    promise(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
