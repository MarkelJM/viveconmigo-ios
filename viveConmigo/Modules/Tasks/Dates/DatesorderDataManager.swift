//
//  DatesorderDataManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import Foundation
import Combine

class DatesOrderDataManager {
    private let firestoreManager = DatesOrderFirestoreManager()
    
    func fetchDateEventById(_ id: String) -> AnyPublisher<DateEvent, Error> {
        return firestoreManager.fetchDateEventById(id)
    }
}
