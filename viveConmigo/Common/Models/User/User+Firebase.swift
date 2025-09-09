//
//  User+Firebase.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//


import FirebaseFirestore

extension User {
    init?(from firestoreData: [String: Any]) {
        guard let id = firestoreData["id"] as? String,
              let email = firestoreData["email"] as? String,
              let firstName = firestoreData["firstName"] as? String,
              let lastName = firestoreData["lastName"] as? String,
              let birthDateTimestamp = firestoreData["birthDate"] as? Timestamp,
              let postalCode = firestoreData["postalCode"] as? String,
              let city = firestoreData["city"] as? String,
              let provinceString = firestoreData["province"] as? String,
              let province = Province(rawValue: provinceString),
              let avatarString = firestoreData["avatar"] as? String,
              let avatar = Avatar(rawValue: avatarString),
              let spotIDs = firestoreData["spotIDs"] as? [String],
              let specialRewards = firestoreData["specialRewards"] as? [String: String],
              let challenges = firestoreData["challengeMadrid"] as? [String: [String]] else {
            return nil
        }
        
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = birthDateTimestamp.dateValue()
        self.postalCode = postalCode
        self.city = city
        self.province = province
        self.avatar = avatar
        self.spotIDs = spotIDs
        self.specialRewards = specialRewards
        self.challenges = challenges
    }
    
    func toFirestoreData() -> [String: Any] {
        return [
            "id": id,
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "birthDate": Timestamp(date: birthDate),
            "postalCode": postalCode,
            "city": city,
            "province": province.rawValue,
            "avatar": avatar.rawValue,
            "spotIDs": spotIDs,
            "specialRewards": specialRewards,
            "challengeMadrid": challenges
        ]
    }
}
