//
//  TakePhotoDataManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import Foundation
import Combine

class TakePhotoDataManager {
    private let firestoreManager = TakePhotoFirestoreManager()
    
    func fetchTakePhotoById(_ id: String) -> AnyPublisher<TakePhoto, Error> {
        return firestoreManager.fetchTakePhotoById(id)
    }
}
