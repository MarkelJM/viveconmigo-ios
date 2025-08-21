//
//  PuzzlePiece.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//


import Foundation

struct PuzzleCoordinate {
    var x: Double
    var y: Double
}

extension PuzzleCoordinate {
    init?(from firestoreData: [String: Any]) {
        if let x = firestoreData["x"] as? Double, let y = firestoreData["y"] as? Double {
            // If coordinates are stored as Double
            self.x = x
            self.y = y
        } else if let xString = firestoreData["x"] as? String, let yString = firestoreData["y"] as? String,
                  let x = Double(xString), let y = Double(yString) {
            // If coordinates are stored as String, try converting them to Double
            self.x = x
            self.y = y
        } else {
            // If neither condition is met, fail to initialize
            return nil
        }
    }

    func toFirestoreData() -> [String: Any] {
        return ["x": x, "y": y]
    }
}
