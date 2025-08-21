//
//  Spot+Firebase.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import FirebaseFirestore

extension Spot {
    init?(from firestoreData: [String: Any]) {
        guard let abstract = firestoreData["abstract"] as? String,
              let activityID = firestoreData["activity_id"] as? String,
              let activityType = firestoreData["activity_type"] as? String,
              let coordinatesData = firestoreData["coordinates"] as? [String: Any],
              let latitude = coordinatesData["latitude"] as? Double,
              let longitude = coordinatesData["longitude"] as? Double,
              let image = firestoreData["image"] as? String,
              let isCompleted = firestoreData["isCompleted"] as? Bool,
              let name = firestoreData["name"] as? String,
              let province = firestoreData["province"] as? String,
              let title = firestoreData["title"] as? String,
              let challenge = firestoreData["challenge"] as? String else {
            return nil
        }

        self.id = firestoreData["id"] as? String ?? ""
        self.abstract = abstract
        self.activityID = activityID
        self.activityType = activityType
        self.coordinates = Coordinates(latitude: latitude, longitude: longitude)
        self.image = image
        self.isCompleted = isCompleted
        self.name = name
        self.province = province
        self.title = title
        self.challenge = challenge
    }
    
    func toFirestoreData() -> [String: Any] {
        return [
            "abstract": abstract,
            "activity_id": activityID,
            "activity_type": activityType,
            "coordinates": [
                "latitude": coordinates.latitude,
                "longitude": coordinates.longitude
            ],
            "image": image,
            "isCompleted": isCompleted,
            "name": name,
            "province": province,
            "title": title,
            "challenge": challenge
        ]
    }
}
