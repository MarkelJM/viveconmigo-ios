//
//  FillGap.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 2/3/25.
//


import Foundation

struct FillGap: Identifiable {
    var id: String
    var province: String
    var question: String
    var images: String
    var correctPositions: [String]
    var customMessage: String
    var correctAnswerMessage: String
    var incorrectAnswerMessage: String
    var isCapital: Bool
    var challenge: String
}
