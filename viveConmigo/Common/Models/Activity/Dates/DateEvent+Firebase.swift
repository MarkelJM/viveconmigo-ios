//
//  DateEvent+Firebase.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//


import Foundation
import FirebaseFirestore

extension DateEvent {
    init?(from firestoreData: [String: Any]) {
        guard let id = firestoreData["id"] as? String,
              let province = firestoreData["province"] as? String,
              let question = firestoreData["question"] as? String,
              let options = firestoreData["options"] as? [String],
              let correctAnswer = firestoreData["correct_answer"] as? [String],
              let customMessage = firestoreData["custom_message"] as? String,
              let correctAnswerMessage = firestoreData["correct_answer_message"] as? String,
              let incorrectAnswerMessage = firestoreData["incorrect_answer_message"] as? String,
              let isCapital = firestoreData["isCapital"] as? Bool,
              let challenge = firestoreData["challenge"] as? String,
              let informationDetail = firestoreData["informationDetail"] as? String else {
            return nil
        }

        self.id = id
        self.province = province
        self.question = question
        self.options = options
        self.correctAnswer = correctAnswer
        self.customMessage = customMessage
        self.correctAnswerMessage = correctAnswerMessage
        self.incorrectAnswerMessage = incorrectAnswerMessage
        self.isCapital = isCapital
        self.challenge = challenge
        self.informationDetail = informationDetail
    }
    
    func toFirestoreData() -> [String: Any] {
        return [
            "id": id,
            "province": province,
            "question": question,
            "options": options,
            "correct_answer": correctAnswer,
            "custom_message": customMessage,
            "correct_answer_message": correctAnswerMessage,
            "incorrect_answer_message": incorrectAnswerMessage,
            "isCapital": isCapital,
            "challenge": challenge,
      ]
    }
}
