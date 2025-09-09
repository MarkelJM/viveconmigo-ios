//
//  Puzzle+Firebase.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//


import Foundation
import FirebaseFirestore

extension Puzzle {
    init?(from firestoreData: [String: Any]) {
        guard let id = firestoreData["id"] as? String,
              let province = firestoreData["province"] as? String,
              let question = firestoreData["question"] as? String,
              let questionImage = firestoreData["questionImage"] as? String,
              let images = firestoreData["images"] as? [String: String],
              let correctPositionsData = firestoreData["correctPositions"] as? [String: [String: Any]],
              let customMessage = firestoreData["custom_message"] as? String,
              let correctAnswerMessage = firestoreData["correct_answer_message"] as? String,
              let incorrectAnswerMessage = firestoreData["incorrect_answer_message"] as? String,
              let isCapital = firestoreData["isCapital"] as? Bool,
              let challenge = firestoreData["challenge"] as? String,
              let informationDetail = firestoreData["informationDetail"] as? String  else {
            return nil
        }

        var correctPositions: [String: PuzzleCoordinate] = [:]
        for (key, value) in correctPositionsData {
            if let coordinate = PuzzleCoordinate(from: value) {
                correctPositions[key] = coordinate
            } else {
                print("Failed to decode correctPositions for key: \(key)")
                return nil
            }
        }

        self.id = id
        self.province = province
        self.question = question
        self.questionImage = questionImage
        self.images = images
        self.correctPositions = correctPositions
        self.customMessage = customMessage
        self.correctAnswerMessage = correctAnswerMessage
        self.incorrectAnswerMessage = incorrectAnswerMessage
        self.isCapital = isCapital
        self.challenge = challenge
        self.informationDetail = informationDetail
    }

    func toFirestoreData() -> [String: Any] {
        let correctPositionsData = correctPositions.mapValues { $0.toFirestoreData() }

        return [
            "id": id,
            "province": province,
            "question": question,
            "questionImage": questionImage,
            "images": images,
            "correctPositions": correctPositionsData,
            "custom_message": customMessage,
            "correct_answer_message": correctAnswerMessage,
            "incorrect_answer_message": incorrectAnswerMessage,
            "isCapital": isCapital,
            "challenge": challenge,
            "informationDetail": informationDetail
        ]
    }
}

