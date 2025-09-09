//
//  Challenge+Firebase.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//


import FirebaseFirestore

extension Challenge {
    init?(from firestoreData: [String: Any]) {
        guard let challengeName = firestoreData["challengeName"] as? String,
              let challengeTaskIDs = firestoreData["challengeTaskIDs"] as? [String],
              let challengeTitle = firestoreData["challengeTitle"] as? String,
              let correctAnswerMessage = firestoreData["correct_answer_message"] as? String,
              let incorrectMessage = firestoreData["incorrect_message"] as? String,
              let image = firestoreData["image"] as? String,
              let isBegan = firestoreData["isBegan"] as? Bool,
              let province = firestoreData["province"] as? String,
              let taskAmount = firestoreData["taskamount"] as? Int,
              let challengeMessage = firestoreData["challengeMessage"] as? String else {
            return nil
        }

        self.id = firestoreData["challengeID"] as? String ?? ""
        self.challengeName = challengeName
        self.challengeTaskIDs = challengeTaskIDs
        self.challengeTitle = challengeTitle
        self.correctAnswerMessage = correctAnswerMessage
        self.incorrectMessage = incorrectMessage
        self.image = image
        self.isBegan = isBegan
        self.province = province
        self.taskAmount = taskAmount
        self.challengeMessage = challengeMessage
    }
    
    func toFirestoreData() -> [String: Any] {
        return [
            "challengeName": challengeName,
            "challengeTaskIDs": challengeTaskIDs,
            "challengeTitle": challengeTitle,
            "correct_answer_message": correctAnswerMessage,
            "incorrect_message": incorrectMessage,
            "image": image,
            "isBegan": isBegan,
            "province": province,
            "taskamount": taskAmount,
            "challengeMessage": challengeMessage
        ]
    }
}
