//
//  Translation+Firebase.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import Foundation
import FirebaseFirestore

extension Translation {
    init?(from firestoreData: [String: Any]) {
        guard let text = firestoreData["text"] as? String else {
            return nil
        }
        self.text = text
        self.url = firestoreData["url"] as? String
    }
}
