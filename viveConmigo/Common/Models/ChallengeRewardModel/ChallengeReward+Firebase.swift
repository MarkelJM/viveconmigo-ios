//
//  ChallengeReward+Firebase.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import Foundation
import FirebaseFirestore


extension ChallengeReward {
    init?(from firestoreData: [String: Any]) {
        guard let id = firestoreData["id"] as? String,
              let abstract = firestoreData["abstract"] as? String,
              let activityID = firestoreData["activity_id"] as? String,
              let activityType = firestoreData["activity_type"] as? String,
              let challenge = firestoreData["challenge"] as? String,
              let challengeTitle = firestoreData["challengeTitle"] as? String,
              let coordinatesMap = firestoreData["coordinates"] as? [String: Any],
              let latitude = coordinatesMap["latitude"] as? Double,
              let longitude = coordinatesMap["longitude"] as? Double,
              let correctAnswerMessage = firestoreData["correct_answer_message"] as? String,
              let prizeImage = firestoreData["prizeImage"] as? String,
              let province = firestoreData["province"] as? String,
              let tasksAmount = firestoreData["tasksAmount"] as? Int else {
            return nil
        }
        
        let coordinates = Coordinates(latitude: latitude, longitude: longitude)
        
        self.id = id
        self.abstract = abstract
        self.activityID = activityID
        self.activityType = activityType
        self.challenge = challenge
        self.challengeTitle = challengeTitle
        self.location = coordinates
        self.correctAnswerMessage = correctAnswerMessage
        self.prizeImage = prizeImage
        self.province = province
        self.tasksAmount = tasksAmount
    }
    
    func toFirestoreData() -> [String: Any] {
        return [
            "id": id,
            "abstract": abstract,
            "activity_id": activityID,
            "activity_type": activityType,
            "challenge": challenge,
            "challengeTitle": challengeTitle,
            "coordinates": [
                "latitude": location.latitude,
                "longitude": location.longitude
            ],
            "correct_answer_message": correctAnswerMessage,
            "prizeImage": prizeImage,
            "province": province,
            "tasksAmount": tasksAmount
        ]
    }
}
