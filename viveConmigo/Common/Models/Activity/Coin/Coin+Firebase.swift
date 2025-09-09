//
//  Coin+Firebase.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//


import Foundation
import FirebaseFirestore

extension Coin {
    init?(from firestoreData: [String: Any]) {
        guard let id = firestoreData["id"] as? String,
              let province = firestoreData["province"] as? String,
              let description = firestoreData["description"] as? String,
              let customMessage = firestoreData["custom_message"] as? String,
              let correctAnswerMessage = firestoreData["correct_answer_message"] as? String,
              let incorrectAnswerMessage = firestoreData["incorrect_answer_message"] as? String,
              let prize = firestoreData["prize"] as? String,
              let isCapital = firestoreData["isCapital"] as? Bool,
              let challenge = firestoreData["challenge"] as? String else {
            return nil
        }

        self.id = id
        self.province = province
        self.description = description
        self.customMessage = customMessage
        self.correctAnswerMessage = correctAnswerMessage
        self.incorrectAnswerMessage = incorrectAnswerMessage
        self.prize = prize
        self.isCapital = isCapital
        self.challenge = challenge
    }
    
    func toFirestoreData() -> [String: Any] {
        return [
            "id": id,
            "province": province,
            "description": description,
            "custom_message": customMessage,
            "correct_answer_message": correctAnswerMessage,
            "incorrect_answer_message": incorrectAnswerMessage,
            "prize": prize,
            "isCapital": isCapital,
            "challenge": challenge
        ]
    }
}
