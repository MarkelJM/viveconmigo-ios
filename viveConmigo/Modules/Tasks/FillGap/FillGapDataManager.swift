//
//  FillGapDataManager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import Foundation
import Combine

class FillGapDataManager {
    private let firestoreManager = FillGapFirestoreManager()
    
    func fetchFillGapById(_ id: String) -> AnyPublisher<FillGap, Error> {
        return firestoreManager.fetchFillGapById(id)
    }
}
