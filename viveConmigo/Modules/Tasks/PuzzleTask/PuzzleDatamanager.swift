//
//  PuzzleDatamanager.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 1/6/25.
//


import Foundation
import Combine
import FirebaseFirestore

class PuzzleDataManager {
    
    private let firestoreManager = PuzzleFirestoreManager()
    
    func fetchPuzzleById(_ id: String) -> AnyPublisher<Puzzle, Error> {
        return firestoreManager.fetchPuzzleById(id)
    }
}
